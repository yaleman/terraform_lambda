output lambda_function_name {
    value = aws_lambda_function.this.function_name
}

output role_arn {
    value = aws_iam_role.lambda_role.arn
}

output role_name {
    value = aws_iam_role.lambda_role.arn
}