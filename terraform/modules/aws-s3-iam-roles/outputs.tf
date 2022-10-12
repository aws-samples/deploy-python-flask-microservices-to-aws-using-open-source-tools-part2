# Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# Permission is hereby granted, free of charge, to any person obtaining a copy of this
# software and associated documentation files (the "Software"), to deal in the Software
# without restriction, including without limitation the rights to use, copy, modify,
# merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
# PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

output "ecs_service_role_arn" {
  value = aws_iam_role.ecs_service_role.arn
}

output "ec2_role_name" {
  value = aws_iam_role.ec2_role.name
}

output "autoscaling_role_arn" {
  value = aws_iam_role.autoscaling_role.arn
}

output "code_commit_repo_name" {
  value = local.codecommit_repo_name
}

output "s3_bucket_name" {
  value = aws_s3_bucket.demoBucket.id
}

output "code_pipeline_service_role_arn" {
  value = aws_iam_role.code_pipeline_service_role.arn
}

output "code_build_pipeline_role_arn" {
  value = aws_iam_role.code_build_pipeline_role.arn
}

output "code_deploy_service_role_arn" {
  value = aws_iam_role.code_deploy_service_role.arn
}

output "lambda_functional_test_role_arn" {
  value = aws_iam_role.lambda_functional_test_role.arn
}

output "account_id" {
  value = local.account_id
}

output "region" {
  value = local.region
}

output "code_pipeline_name" {
  value = var.code_pipeline_name
}