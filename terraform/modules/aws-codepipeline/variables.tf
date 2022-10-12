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

variable "code_pipeline_name" {
  description = "CodePipeline Name"
  type        = string
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

variable "private_subnet_1_id" {
  description = "Private Subnet 1 ID"
  type        = string
}

variable "private_subnet_2_id" {
  description = "Private Subnet 2 ID"
  type        = string
}

variable "ecs_cluster_name" {
  description = "ECS Cluster Name"
  type        = string
}

variable "ecr_repo_url" {
  description = "ECR Repo URL"
  type        = string
}

variable "flask_container_name" {
  description = "ECR container name"
  type        = string
}

variable "aws_ecs_service_name" {
  description = "ECS Service Name"
  type        = string
}

variable "aws_lb_listener_arn" {
  description = "LB Listener ARN"
  type        = string
}

variable "aws_lb_test_listener_arn" {
  description = "LB Test Listener ARN"
  type        = string
}

variable "ecs_rest_api_tg_blue_name" {
  description = "ECS Blue TG Name"
  type        = string
}

variable "ecs_rest_api_tg_green_name" {
  description = "ECS Green TG Name"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 bucket name"
  type        = string
}

variable "code_commit_repo_name" {
  description = "CodeCommit repository name"
  type        = string
}

variable "code_build_pipeline_role_arn" {
  description = "CodeBuild pipeline ARN."
  type        = string
}

variable "code_pipeline_service_role_arn" {
  description = "CodePipeline service role ARN."
  type        = string
}

variable "account_id" {
  description = "Account ID"
  type        = string
}

variable "branch_name" {
  description = "Branch name that will trigger pipeline."
  type        = string
  default     = "main"
}

variable "ecs_sg_id" {
  description = "ECS Security Group ID."
  type        = string
}

variable "code_deploy_service_role_arn" {
  description = "CodeDeploy Service role ARN."
  type        = string
}

variable "ecs_task_definition_arn" {
  description = "ECS Task Definition ARN."
  type        = string
}

variable "test_report_directory" {
  description = "Pytest test report directory."
  type        = string
  default     = "app_pytest_report"
}

variable "test_report_filename" {
  description = "Pytest test report filename"
  type        = string
  default     = "app_pytest_report.xml"  
}

variable "code_build_env_compute_type" {
  description = "CodeBuild compute type"
  type        = string
  default     = "BUILD_GENERAL1_SMALL"  
}

variable "code_build_env_image" {
  description = "CodeBuild image"
  type        = string
  default     = "aws/codebuild/standard:4.0"  
}

variable "code_build_env_type" {
  description = "CodeBuild env type"
  type        = string
  default     = "LINUX_CONTAINER"  
}

variable "code_build_artifact_type" {
  description = "CodeBuild artifact type"
  type        = string
  default     = "CODEPIPELINE"  
}

variable "codedeploy_app_platform" {
  description = "CodeBuild app compute platform"
  type        = string
  default     = "ECS"  
}

variable "code_build_source_type" {
  description = "CodeBuild source type"
  type        = string
  default     = "CODEPIPELINE"  
}

variable "codedeploy_dg_config_name" {
  description = "CodeDeploy deployment config name"
  type        = string
  default     = "CodeDeployDefault.ECSAllAtOnce"  
}

variable "codedeploy_dg_rollback_events" {
  description = "CodeDeploy deployment group rollback events"
  type        = string
  default     = "DEPLOYMENT_FAILURE"  
}

variable "codedeploy_dg_tg_deployment_ready_option" {
  description = "CodeDeploy deployment group deployment config ready option"
  type        = string
  default     = "CONTINUE_DEPLOYMENT"  
}

variable "codedeploy_dg_tg_termination_success_action" {
  description = "CodeDeploy deployment group blue green deployment terminate action"
  type        = string
  default     = "TERMINATE"  
}

variable "codedeploy_dg_tg_termination_wait_time" {
  description = "CodeDeploy deployment group deployment terminiation wait time"
  type        = number
  default     = 5  
}

variable "codedeploy_dg_deployment_style_type" {
  description = "CodeDeploy deployment group deployment deployment style type"
  type        = string
  default     = "BLUE_GREEN"  
}

variable "codedeploy_dg_deployment_style_option" {
  description = "CodeDeploy deployment group deployment deployment style type"
  type        = string
  default     = "WITH_TRAFFIC_CONTROL"  
}

variable "codepipeline_artifact_store_type" {
  description = "CodePipeline artifact store type"
  type        = string
  default     = "S3"  
}

variable "codepipeline_source_stage_name" {
  description = "CodePipeline source stage name"
  type        = string
  default     = "Source"  
}

variable "codepipeline_source_stage_owner" {
  description = "CodePipeline source stage owner"
  type        = string
  default     = "AWS"  
}

variable "codepipeline_source_stage_provider" {
  description = "CodePipeline source stage provider"
  type        = string
  default     = "CodeCommit"  
}

variable "codepipeline_source_stage_version" {
  description = "CodePipeline source stage version"
  type        = string
  default     = "1"  
}

variable "codepipeline_source_stage_output_artifacts" {
  description = "CodePipeline source stage output artifacts"
  type        = string
  default     = "source_output"  
}

variable "codepipeline_build_stage_name" {
  description = "CodePipeline build stage name"
  type        = string
  default     = "Build"  
}

variable "codepipeline_build_stage_owner" {
  description = "CodePipeline build stage owner"
  type        = string
  default     = "AWS"  
}

variable "codepipeline_build_stage_provider" {
  description = "CodePipeline build stage provider"
  type        = string
  default     = "CodeBuild"  
}

variable "codepipeline_build_stage_version" {
  description = "CodePipeline build stage version"
  type        = string
  default     = "1"  
}

variable "codepipeline_build_stage_output_artifacts" {
  description = "CodePipeline build stage output artifacts"
  type        = string
  default     = "app"  
}

variable "codepipeline_deploy_stage_name" {
  description = "CodePipeline deploy stage name"
  type        = string
  default     = "Deploy"  
}

variable "codepipeline_deploy_stage_owner" {
  description = "CodePipeline deploy stage owner"
  type        = string
  default     = "AWS"  
}

variable "codepipeline_deploy_stage_provider" {
  description = "CodePipeline deploy stage provider"
  type        = string
  default     = "CodeDeployToECS"  
}

variable "codepipeline_deploy_stage_version" {
  description = "CodePipeline deploy stage version"
  type        = string
  default     = "1"  
}

variable "task_definition_template_artifact" {
  description = "CodePipeline task definition template artifact"
  type        = string
  default     = "app"  
}

variable "appspec_template_artifact" {
  description = "CodePipeline appspec template artifact"
  type        = string
  default     = "app"  
}