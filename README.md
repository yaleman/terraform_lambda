# Terraform-Lambda

Quick module for spinning up a terraform and scheduling it to run periodically.

Due to limitations I couldn't figure out how to fix, if you don't set an environment variable it'll set a default one of `"supersecretenvironmentvariable" = "thisisadefaultsetting"`.

## Variables

| Name | Type | Description | Notes |
| ---  | --- | --- | --- |
| function_name | string | what it'll be called in AWS | |
| lambda_handler | string |  | |
| lambda_runtime | string | Python3.8 or whatever you want to run it in | |
| aws_region | string | | |
| aws_profile | string | | |
| lambda_run_on_schedule | bool | Enable the schedule runner | Defaults to false |
| lambda_schedule_expression | string | When to run it via EventBridge | <https://docs.aws.amazon.com/eventbridge/latest/userguide/scheduled-events.html> |
| lambda_timeout | number | The maximum runtime in seconds | |
| lambda_memory | number | The configured memory (in megabytes) the function's allowed to use | |
| layer_arns | list(string) | A list of layer ARNs to include | |
| lambda_script_filename | string | The original filename on the filesystem of the function | |
| lambda_script_additional_files | list(string) | Additional files to include in the package. | |
| environment_variables | map(string) | A map of environment variables | By default, it'll set "supersecretenvironmentvariable" = "thisisadefaultsetting"|

## Changelog

- 1.0.4 - Compatibility with Terraform 0.13+
- 1.0.6 - AWS provider >5.10
