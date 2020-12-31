# Terraform-Lambda

Quick module for spinning up a terraform and scheduling it to run periodically.

Due to limitations I couldn't figure out how to fix, if you don't set an environment variable it'll set a default one of `"supersecretenvironmentvariable" = "thisisadefaultsetting"`.

Variables

| Name | Description | Notes |
| ---  | --- | --- |
| function_name | what it'll be called in AWS | |
| lambda_handler | | |
| lambda_runtime | Python3.8 or whatever you want to run it in | |
| aws_region | | |
| aws_profile | | |
| lambda_schedule_expression | When to run it via EventBridge | https://docs.aws.amazon.com/eventbridge/latest/userguide/scheduled-events.html |
| lambda_timeout | The maximum runtime in seconds | |
| lambda_memory | The configured memory the function's allowed to use | |
| layer_arns | A list of layer ARNs to include | |
| lambda_script_filename | The original filename on the filesystem of the function | |
| environment_variables | A map of environment variables | By default, it'll set "supersecretenvironmentvariable" = "thisisadefaultsetting"|
