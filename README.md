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
| log_retention_days | string | Number of days to keep the function logs | defaults to 1 |

## Changelog

- 1.0.4 - Compatibility with Terraform 0.13+
- 1.0.6 - AWS provider >5.10
- 1.0.9 - Removing `provider` block

# Terraform Documentation

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.10 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.4.1 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.31.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.schedule_lambda_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.schedule_lambda_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_log_group.log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.lambda_basic_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.allow_cloudwatch_to_run_lambdas](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [archive_file.lambda](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_profile"></a> [aws\_profile](#input\_aws\_profile) | The profile we will use to build and implement this | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The region that all these things are built in | `string` | n/a | yes |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | Environment block | `map(string)` | `{}` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | Name of the function once it's uploaded | `string` | n/a | yes |
| <a name="input_lambda_handler"></a> [lambda\_handler](#input\_lambda\_handler) | Function name in the script that the lambda will run - feeds aws\_lambda\_function.this.handler | `string` | `"lambda_handler"` | no |
| <a name="input_lambda_memory"></a> [lambda\_memory](#input\_lambda\_memory) | Allocated memory for function | `number` | `128` | no |
| <a name="input_lambda_run_on_schedule"></a> [lambda\_run\_on\_schedule](#input\_lambda\_run\_on\_schedule) | Set this to false if you don't want to schedule it | `bool` | `false` | no |
| <a name="input_lambda_runtime"></a> [lambda\_runtime](#input\_lambda\_runtime) | Runtime that the lambda runs in | `string` | `"python3.8"` | no |
| <a name="input_lambda_schedule_expression"></a> [lambda\_schedule\_expression](#input\_lambda\_schedule\_expression) | How often to run the lambda | `string` | `""` | no |
| <a name="input_lambda_script_additional_files"></a> [lambda\_script\_additional\_files](#input\_lambda\_script\_additional\_files) | Additional script files to add to the package | `list(string)` | `[]` | no |
| <a name="input_lambda_script_filename"></a> [lambda\_script\_filename](#input\_lambda\_script\_filename) | Source filename of the lambda to upload | `string` | n/a | yes |
| <a name="input_lambda_timeout"></a> [lambda\_timeout](#input\_lambda\_timeout) | Maximum runtime in seconds of your lambda | `number` | `30` | no |
| <a name="input_layer_arns"></a> [layer\_arns](#input\_layer\_arns) | List of ARNs of layers to include in the function runtime | `list(string)` | `[]` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | Number of days to keep the logs in cloudwatch | `string` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lambda_function_name"></a> [lambda\_function\_name](#output\_lambda\_function\_name) | n/a |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | n/a |
| <a name="output_role_name"></a> [role\_name](#output\_role\_name) | n/a |
<!-- END_TF_DOCS -->
