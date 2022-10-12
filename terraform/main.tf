terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.60.0"
    }
  }
}

resource "aws_codecommit_repository" "flask_demo_repo" {
  repository_name = module.aws-s3-iam-roles.code_commit_repo_name
}

output "aws_lb_dns_name" {
  value = module.aws-ecs.aws_lb_dns_name
}

module "aws-network" {
  source = "./modules/aws-network"
}

module "aws-s3-iam-roles" {
  source                                = "./modules/aws-s3-iam-roles"
  codedeploy_demo_app_name              = var.codedeploy_demo_app_name
  codedeploy_deployment_demo_group_name = var.codedeploy_deployment_demo_group_name
  code_build_project_name               = var.code_build_project_name
  lambda_test_function_name             = var.lambda_test_function_name
}

module "aws-ecr" {
  source = "./modules/aws-ecr"
}

module "aws-ecs" {
  source               = "./modules/aws-ecs"
  vpc                  = module.aws-network.vpc_id
  public_subnet_1      = module.aws-network.public_subnet_1_id
  public_subnet_2      = module.aws-network.public_subnet_2_id
  private_subnet_1     = module.aws-network.private_subnet_1_id
  private_subnet_2     = module.aws-network.private_subnet_2_id
  ecs_service_role_arn = module.aws-s3-iam-roles.ecs_service_role_arn
  ec2_role_name        = module.aws-s3-iam-roles.ec2_role_name
  autoscaling_role_arn = module.aws-s3-iam-roles.autoscaling_role_arn
  ecr_repo_url         = module.aws-ecr.ecr_repo_url
  region               = module.aws-s3-iam-roles.region
}

module "aws-codepipeline" {
  source                                = "./modules/aws-codepipeline"
  code_commit_repo_name                 = module.aws-s3-iam-roles.code_commit_repo_name
  s3_bucket_name                        = module.aws-s3-iam-roles.s3_bucket_name
  code_pipeline_service_role_arn        = module.aws-s3-iam-roles.code_pipeline_service_role_arn
  code_build_pipeline_role_arn          = module.aws-s3-iam-roles.code_build_pipeline_role_arn
  code_deploy_service_role_arn          = module.aws-s3-iam-roles.code_deploy_service_role_arn
  account_id                            = module.aws-s3-iam-roles.account_id
  code_pipeline_name                    = module.aws-s3-iam-roles.code_pipeline_name
  private_subnet_1_id                   = module.aws-network.private_subnet_1_id
  private_subnet_2_id                   = module.aws-network.private_subnet_2_id
  flask_container_name                  = module.aws-ecs.flask_container_name
  ecs_cluster_name                      = module.aws-ecs.ecs_cluster_name
  ecr_repo_url                          = module.aws-ecr.ecr_repo_url
  aws_ecs_service_name                  = module.aws-ecs.aws_ecs_service_name
  aws_lb_listener_arn                   = module.aws-ecs.aws_lb_listener_arn
  aws_lb_test_listener_arn              = module.aws-ecs.aws_lb_test_listener_arn
  ecs_rest_api_tg_blue_name             = module.aws-ecs.ecs_rest_api_tg_blue_name
  ecs_rest_api_tg_green_name            = module.aws-ecs.ecs_rest_api_tg_green_name
  ecs_sg_id                             = module.aws-ecs.ecs_sg_id
  ecs_task_definition_arn               = module.aws-ecs.ecs_task_definition_arn
  codedeploy_demo_app_name              = var.codedeploy_demo_app_name
  codedeploy_deployment_demo_group_name = var.codedeploy_deployment_demo_group_name
  code_build_project_name               = var.code_build_project_name
}
