variable function_name {
    type = string
    description = "Name of the function once it's uploaded"
}

variable lambda_handler {
    type = string
    default = "lambda_handler"
    description = "Function name in the script that the lambda will run - feeds aws_lambda_function.this.handler"
}

variable lambda_runtime {
    type = string
    default = "python3.8"
    description = "Runtime that the lambda runs in"
}

variable aws_region {
    type = string
    description = "The region that all these things are built in"
}

variable aws_profile {
    type=string
    description = "The profile we will use to build and implement this"
}

variable lambda_run_on_schedule {
    type = bool
    default = false
    description = "Set this to false if you don't want to schedule it"
}

variable lambda_schedule_expression {
    type = string
    description = "How often to run the lambda"
    default = ""
}

variable lambda_timeout {
    type = number
    description = "Maximum runtime in seconds of your lambda"
    default = 30
}

variable lambda_memory {
    type = number
    description = "Allocated memory for function"
    default = 128 # minimum
}

variable layer_arns {
    type = list(string)
    description = "List of ARNs of layers to include in the function runtime"
    default = []
}

variable lambda_script_filename {
    type = string
    description = "Source filename of the lambda to upload"
}

variable lambda_script_additional_files {
    type = list(string)
    description = "Additional script files to add to the package"
    default = []
}

variable environment_variables {
    description = "Environment block"
    type = map(string)
    #default = {
    #    "supersecretenvironmentvariable" = "thisisadefaultsetting"
    #}
    default = {}
}