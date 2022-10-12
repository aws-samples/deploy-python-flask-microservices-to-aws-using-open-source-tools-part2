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

resource "aws_codebuild_project" "flask_codebuild_project" {
  name              = var.code_build_project_name
  description       = "Codebuild for the ECS Green/Blue Example app"
  service_role      = var.code_build_pipeline_role_arn

  artifacts {
    type = var.code_build_artifact_type
  }

  environment {
    compute_type    = var.code_build_env_compute_type
    image           = var.code_build_env_image
    type            = var.code_build_env_type
    privileged_mode = true

    environment_variable {
      name  = "ECR_REPO_URL"
      value = var.ecr_repo_url
    }
    environment_variable {
      name  = "TASK_DEFINITION"
      value = var.ecs_task_definition_arn
    }

    environment_variable {
      name  = "CONTAINER_NAME"
      value = var.flask_container_name
    }

    environment_variable {
      name  = "PRIVATE_SUBNET_1"
      value = var.private_subnet_1_id
    }

    environment_variable {
      name  = "PRIVATE_SUBNET_2"
      value = var.private_subnet_2_id
    }

    environment_variable {
      name  = "SECURITY_GROUP"
      value = var.ecs_sg_id
    }

    environment_variable {
      name = "TEST_REPORT_DIRECTORY"
      value = var.test_report_directory
    }

    environment_variable {
      name = "TEST_REPORT_FILENAME"
      value = var.test_report_filename
    }

  }

  source {
    type = var.code_build_source_type
  }
}

resource "aws_codedeploy_app" "codedeploy_demo_app" {
  compute_platform          = var.codedeploy_app_platform
  name                      = var.codedeploy_demo_app_name
}

resource "aws_codedeploy_deployment_group" "codedeploy_deployment_demo_group" {
  app_name                  = aws_codedeploy_app.codedeploy_demo_app.name
  deployment_config_name    = var.codedeploy_dg_config_name
  deployment_group_name     = var.codedeploy_deployment_demo_group_name
  service_role_arn          = var.code_deploy_service_role_arn

  auto_rollback_configuration {
    enabled                 = true
    events                  = ["${var.codedeploy_dg_rollback_events}"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout     = var.codedeploy_dg_tg_deployment_ready_option
    }

    terminate_blue_instances_on_deployment_success {
      action                           = var.codedeploy_dg_tg_termination_success_action
      termination_wait_time_in_minutes = var.codedeploy_dg_tg_termination_wait_time
    }
  }

  deployment_style {
    deployment_option = var.codedeploy_dg_deployment_style_option
    deployment_type   = var.codedeploy_dg_deployment_style_type
  }

  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = var.aws_ecs_service_name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.aws_lb_listener_arn]
      }

      test_traffic_route {
        listener_arns = [var.aws_lb_test_listener_arn]
      }

      target_group {
        name = var.ecs_rest_api_tg_blue_name
      }

      target_group {
        name = var.ecs_rest_api_tg_green_name
      }
    }
  }
}

resource "aws_codepipeline" "codepipeline" {
  name     = var.code_pipeline_name
  role_arn = var.code_pipeline_service_role_arn

  artifact_store {
    location = var.s3_bucket_name
    type     = var.codepipeline_artifact_store_type
  }

  stage {
    name = var.codepipeline_source_stage_name

    action {
      name             = var.codepipeline_source_stage_name
      category         = var.codepipeline_source_stage_name
      owner            = var.codepipeline_source_stage_owner
      provider         = var.codepipeline_source_stage_provider
      version          = var.codepipeline_source_stage_version
      output_artifacts = ["${var.codepipeline_source_stage_output_artifacts}"]

      configuration = {
        RepositoryName       = var.code_commit_repo_name
        BranchName           = var.branch_name
        PollForSourceChanges = "false"
      }
    }
  }

  stage {
    name = var.codepipeline_build_stage_name

    action {
      name     = var.codepipeline_build_stage_name
      category = var.codepipeline_build_stage_name
      owner    = var.codepipeline_build_stage_owner
      provider = var.codepipeline_build_stage_provider
      version  = var.codepipeline_build_stage_version

      input_artifacts  = ["${var.codepipeline_source_stage_output_artifacts}"]
      output_artifacts = ["${var.codepipeline_build_stage_output_artifacts}"]

      configuration = {
        ProjectName = aws_codebuild_project.flask_codebuild_project.name
      }
    }
  }

  stage {
    name = var.codepipeline_deploy_stage_name

    action {
      name            = var.codepipeline_deploy_stage_name
      category        = var.codepipeline_deploy_stage_name
      owner           = var.codepipeline_deploy_stage_owner
      provider        = var.codepipeline_deploy_stage_provider
      version         = var.codepipeline_deploy_stage_version
      input_artifacts = ["${var.codepipeline_build_stage_output_artifacts}"]

      configuration = {
        ApplicationName                = aws_codedeploy_app.codedeploy_demo_app.name
        DeploymentGroupName            = aws_codedeploy_deployment_group.codedeploy_deployment_demo_group.deployment_group_name
        TaskDefinitionTemplateArtifact = var.task_definition_template_artifact
        AppSpecTemplateArtifact        = var.appspec_template_artifact
      }
    }
  }
}