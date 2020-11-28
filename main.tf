provider aws {
    profile = var.aws_profile
    region = var.aws_region
}

# this is really only needed if there's multiple files or it's huge
data archive_file hello_world {
  type        = "zip"
  output_path = "hello_world.zip"
  source {
    content  = file("hello_world.py")
    filename = "hello_world.py"
  }
}

# the lambda function itself
resource aws_lambda_function hello_world {
    function_name = var.project_name
    handler = "hello_world.lambda_handler"

    runtime = "python3.8"
    timeout = 1 # maximum is 900 seconds (15 minutes)
    memory_size = 128 # the minimum (https://docs.aws.amazon.com/lambda/latest/dg/gettingstarted-limits.html)
    
    filename = data.archive_file.hello_world.output_path
    source_code_hash = data.archive_file.hello_world.output_base64sha256

    role = aws_iam_role.lambda_role.arn

    layers = [
      # handy if you want to include external things, in this case we're using
      # requests and loguru from Klayers
      local.lambda_layer_requests_arn,
      local.lambda_layer_loguru_arn,

    ]
    lifecycle {
        ignore_changes = [
            # it's pretty common to ignore this if you're 
            # doing dumb things like including auth tokens or secrets 
            # in the environment variables
            # environment,
        ]
    }

    environment {
      variables = {
        THING_TO_SAY = "Hello world"
      }
    }
}

# it's a smart idea to set the log retention
resource aws_cloudwatch_log_group log_group {
  name              = "/aws/lambda/${aws_lambda_function.hello_world.function_name}"
  retention_in_days = 1
}

# Examples of how to grab layers for python from KLayers
data http requests_layers {
  url = "https://api.klayers.cloud/api/v1/layers/${var.aws_region}/requests"
  request_headers = {
    Accept = "application/json"
  }
}
data http loguru_layers {
  url = "https://api.klayers.cloud/api/v1/layers/${var.aws_region}/loguru"
  request_headers = {
    Accept = "application/json"
  }
}

# this parses the results from the HTTP calls above and allows you to get the ARN for the layers
locals {
  lambda_layer_requests_arn = [for entry in jsondecode(data.http.requests_layers.body) :  entry.arn if entry["deployStatus"] != "deprecated" ][0]
  lambda_layer_loguru_arn = [for entry in jsondecode(data.http.loguru_layers.body) :  entry.arn if entry["deployStatus"] != "deprecated" ][0]
}

# role for the lambda to run under, to do the things.
resource aws_iam_role lambda_role {
  name = "lambda_${var.project_name}"
  assume_role_policy = file("iam_role_policy_lambda.json")
}

# An additional policy for the lambda, as an example - gives a lot of access to SQS
# resource aws_iam_role_policy lambda_policy {
#   name = "lambda_${var.project_name}"
#   role = aws_iam_role.lambda_role.id
#   policy = file("iam_policy_example_sqs.json")
# }

# Give the role access to the basic Lambda role
resource aws_iam_role_policy_attachment lambda_basic_execution_role {
    role = aws_iam_role.lambda_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# build an AWS Event Bridget schedule to run every x time
resource aws_cloudwatch_event_rule schedule_lambda_execution {
  name = "${var.project_name}_schedule"
  schedule_expression = var.lambda_schedule_expression
}

# tell Event Bridge to run our Lambda
resource aws_cloudwatch_event_target schedule_lambda_execution {
  rule = aws_cloudwatch_event_rule.schedule_lambda_execution.name
  arn = aws_lambda_function.hello_world.arn
}

resource aws_lambda_permission allow_cloudwatch_to_run_lambdas {
  statement_id  = "AllowExecutionFromCloudWatch-${var.project_name}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hello_world.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.schedule_lambda_execution.arn
}
