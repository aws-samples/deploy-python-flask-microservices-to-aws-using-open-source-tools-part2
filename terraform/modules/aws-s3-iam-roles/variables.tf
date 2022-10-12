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

variable "ecs_policy_name" {
  description = "ECS policy name"
  type        = string
  default     = "ecs_policy"
}

variable "ecr_repository_name" {
  description = "ECR repository name"
  type        = string
  default     = "flask-ecr-repo"
}

variable "ecs_service_role_name" {
  description = "ECS service role name"
  type        = string
  default     = "ecs_service_role"
}

variable "ec2_instance_role_name" {
  description = "EC2 instance role name"
  type        = string
  default     = "ec2_role"
}

variable "autoscaling_role_name" {
  description = "ASG role name"
  type        = string
  default     = "autoscaling_role"
}

variable "lambda_build_role_name" {
  description = "Lambda build role name"
  type        = string
  default     = "lambda_build_role"
}

variable "ecs_load_balancing_policy_name" {
  description = "ECS LoadBalancing permissions name"
  type        = string
  default     = "ecs_load_balancing_policy"
}

variable "lambda_functional_test_policy_name" {
  description = "Functional Test Lambda permissions name"
  type        = string
  default     = "lambda_functional_test_policy"
}

variable "lambda_test_codedeploy_policy_name" {
  description = "Functional Test Lambda CodeDeploy permissions name"
  type        = string
  default     = "lambda_test_codedeploy_policy"
}

variable "ecs_elb_targets_policy_name" {
  description = "ECS LoadBalancing Targets permissions name"
  type        = string
  default     = "ecs_elb_targets_policy"
}

variable "dynamo_policy_name" {
  description = "DynamoDB policy name"
  type        = string
  default     = "dynamo_policy"
}

variable "autoscaling_policy_name" {
  description = "Autoscaling policy name"
  type        = string
  default     = "autoscaling_policy"
}

variable "cloudformation_policy_name" {
  description = "CloudFormation policy name"
  type        = string
  default     = "cloudformation_policy"
}

variable "pipeline_s3_bucket_objects_policy_name" {
  description = "Pipeline S3 Bucket policy name"
  type        = string
  default     = "pipeline_artifacts_s3_bucket_policy"
}

variable "ecr_permissions_policy_name" {
  description = "ECR permissions name"
  type        = string
  default     = "ecr_permissions_policy"
}

variable "code_pipeline_base_policy_name" {
  description = "CodePipeline base policy name"
  type        = string
  default     = "code_pipeline_base_policy"
}

variable "iam_pass_role_policy_name" {
  description = "IAM Pass role policy name"
  type        = string
  default     = "iam_pass_role_policy"
}

variable "ssm_parameter_policy_name" {
  description = "SSM parameter policy name"
  type        = string
  default     = "ssm_parameter_policy"
}

variable "session_manager_policy_name" {
  description = "Session Manager policy name"
  type        = string
  default     = "session_manager_policy"
}

variable "codedeploy_execution_status_policy_name" {
  description = "CodeDeploy execution status policy name"
  type        = string
  default     = "codedeploy_execution_status_policy"
}

variable "code_pipeline_name" {
  description = "CodePipeline name"
  type        = string
  default     = "flask-demo-pipeline"
}

variable "code_deploy_service_role_name" {
  description = "CodeDeploy service role name"
  type        = string
  default     = "code_deploy_service_role"
}

variable "lambda_functional_test_role_name" {
  description = "Functional Test Lambda execution role name"
  type        = string
  default     = "lambda_functional_test_role"
}

variable "code_pipeline_service_role_name" {
  description = "CodePipeline service role name"
  type        = string
  default     = "code_pipeline_service_role"
}

variable "codedeploy_lb_ecs_policy_name" {
  description = "CodeDeploy ECS and Load Balancing policy."
  type        = string
  default     = "code_deploy_lb_ecs_policy"
}

variable "codedeploy_s3_bucket_objects_policy_name" {
  description = "CodeDeploy S3 read permissions."
  type        = string
  default     = "codedeploy_s3_bucket_objects_policy"
}

variable "codedeploy_pass_role_policy_name" {
  description = "CodeDeploy pass role permissions."
  type        = string
  default     = "codedeploy_pass_role_policy"
}

variable "codepipeline_codedeploy_policy_name" {
  description = "CodePipeline CodeDeploy permissions."
  type        = string
  default     = "codepipeline_codedeploy_policy"
}

variable "codedeploy_demo_app_name" {
  description = "CodeDeploy App Name"
  type        = string
}

variable "codedeploy_deployment_demo_group_name" {
  description = "CodeDeploy deployment group name"
  type        = string
}

variable "code_build_project_name" {
  description = "CodeBuild Project Name"
  type        = string
}

variable "lambda_test_function_name" {
  description = "Flask Lambda test function name"
  type        = string
}