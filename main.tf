provider aws {
    profile = var.aws_profile
    region = var.aws_region
}

# this is really only needed if there's multiple files or it's huge
data archive_file lambda {
  type        = "zip"
  output_path = "${var.function_name}.zip"
  source {
    content  = file(var.lambda_script_filename)
    filename = var.lambda_script_filename
  }
}

# the lambda function itself
resource aws_lambda_function this {
    function_name = var.function_name
    handler = "${var.lambda_script_filename}.${var.lambda_handler}"

    runtime = var.lambda_runtime
    timeout = var.lambda_timeout # maximum is 900 seconds (15 minutes), default is 30
    memory_size = var.lambda_memory # the minimum is 128 (https://docs.aws.amazon.com/lambda/latest/dg/gettingstarted-limits.html)
    
    filename = data.archive_file.lambda.output_path
    source_code_hash = data.archive_file.lambda.output_base64sha256

    role = aws_iam_role.lambda_role.arn

    layers = var.layer_arns


    environment {
      variables = var.environment_variables
    }
}

# it's a smart idea to set the log retention
resource aws_cloudwatch_log_group log_group {
  name              = "/aws/lambda/${aws_lambda_function.this.function_name}"
  retention_in_days = 1
}

# role for the lambda to run under, to do the things.
resource aws_iam_role lambda_role {
  name = "lambda_${var.function_name}"
  assume_role_policy = file("iam_role_policy_lambda.json")
}

# Give the role access to the basic Lambda role
resource aws_iam_role_policy_attachment lambda_basic_execution_role {
    role = aws_iam_role.lambda_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# build an AWS Event Bridge schedule to run every x time
resource aws_cloudwatch_event_rule schedule_lambda_execution {
  name = "${var.function_name}_schedule"
  schedule_expression = var.lambda_schedule_expression
}

# tell Event Bridge to run our Lambda
resource aws_cloudwatch_event_target schedule_lambda_execution {
  rule = aws_cloudwatch_event_rule.schedule_lambda_execution.name
  arn = aws_lambda_function.this.arn
}

resource aws_lambda_permission allow_cloudwatch_to_run_lambdas {
  statement_id  = "AllowExecutionFromCloudWatch-${var.function_name}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.schedule_lambda_execution.arn
}