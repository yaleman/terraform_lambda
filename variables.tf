variable project_name {
    type = string
}

variable aws_region {
    type = string
    description = "The region that all these things are built in"
}

variable aws_profile {
    type=string
    description = "The profile we will use to build and implement this"
}

variable lambda_schedule_expression {
    type = string
    description = "How often to run the lambda"
}
