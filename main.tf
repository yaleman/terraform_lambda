module amber_stats {
  source = "github.com/yaleman/terraform_lambda"

  function_name = "amber_stats_collect"

  aws_profile = "personal-aussiebb"
  aws_region = "us-east-1"

  lambda_script_filename = "collector.py"

  # This can be something like a cron(*/5 * * * *), or rate(1 day) or rate(5 minutes) etc.
  # https://docs.aws.amazon.com/eventbridge/latest/userguide/scheduled-events.html
  lambda_schedule_expression = "rate(30 minutes)"

}

terraform {
  backend "s3" {
    profile = "personal-aussiebb"
    bucket = "yaleman-terraform-state"
    key    = "amber_stats_collect.tfstate"
    region = "us-east-1"
  }
}
