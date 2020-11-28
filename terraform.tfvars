project_name = "hello_world"

aws_region = "us-east-1"

# This can be something like a cron(*/5 * * * *), or rate(1 day) or rate(5 minutes) etc.
# https://docs.aws.amazon.com/eventbridge/latest/userguide/scheduled-events.html
lambda_schedule_expression = "rate(1 minute)"
