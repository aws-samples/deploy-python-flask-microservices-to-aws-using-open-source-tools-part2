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

variable "ecr_policy_name" {
  description = "ECR policy name"
  type        = string
  default     = "ecr_policy"
}

variable "cloudformation_policy_name" {
  description = "CloudFormation policy name"
  type        = string
  default     = "cloudformation_policy"
}

variable "sam_pipeline_policy_name" {
  description = "SAM Pipeline policy name"
  type        = string
  default     = "sam_pipeline_policy"
}

variable "code_pipeline_name" {
  description = "CodePipeline Name"
  type        = string
  default     = "flask-demo-app-pipeline"
}

variable "codedeploy_demo_app_name" {
  description = "CodeDeploy App Name"
  type        = string
  default     = "flask-demo-app"
}

variable "codedeploy_deployment_demo_group_name" {
  description = "CodeDeploy deployment group name"
  type        = string
  default     = "demo-group"
}

variable "code_build_project_name" {
  description = "CodeBuild Project Name"
  type        = string
  default     = "flask-demo-app-build-project"
}

variable "lambda_test_function_name" {
  description = "Flask Lambda Function name"
  type        = string
  default     = "flask-api-test-function"
}