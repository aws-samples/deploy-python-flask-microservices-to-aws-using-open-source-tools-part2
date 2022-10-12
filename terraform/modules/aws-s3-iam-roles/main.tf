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

locals {
  account_id = data.aws_caller_identity.current.account_id
  region = data.aws_region.current.name
  codecommit_repo_name = data.aws_codecommit_repository.flask_demo_repo.repository_name
  codecommit_repo_arn = data.aws_codecommit_repository.flask_demo_repo.arn
}
resource "aws_s3_bucket" "demoBucket" {
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "demo_bucket" {
  bucket                  = aws_s3_bucket.demoBucket.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_iam_policy" "ecr_policy" {
  name        = var.ecr_policy_name
  path        = "/"
  description = "My ECR policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
          "ecs:DiscoverPollEndpoint",
          "ecs:DescribeTaskDefinition",
          "ecs:RegisterTaskDefinition"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_policy" "ecs_policy" {
  name        = var.ecs_policy_name
  path        = "/"
  description = "ECS policy."
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:DescribeTags",
          "ecs:CreateCluster",
          "ecs:DeregisterContainerInstance",
          "ecs:DiscoverPollEndpoint",
          "ecs:Poll",
          "ecs:RegisterContainerInstance",
          "ecs:StartTelemetrySession",
          "ecs:UpdateContainerInstancesState",
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
          "ecs:DescribeServices",
          "ecs:UpdateService",
          "ecs:SubmitTaskStateChange",
          "ecs:Submit*"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:ecs:${local.region}:${local.account_id}:*/*",
          "arn:aws:ec2:${local.region}:${local.account_id}:*/*"
        ]
      },
    ]
  })
}

resource "aws_iam_policy" "ecs_load_balancing_policy" {
  name               = var.ecs_load_balancing_policy_name
  path               = "/"
  description        = "ECS ELB policy."
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
          "elasticloadbalancing:DeregisterTargets",
          "elasticloadbalancing:Describe*",
          "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
          "elasticloadbalancing:RegisterTargets",
          "ec2:Describe*",
          "ec2:AuthorizeSecurityGroupIngress"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:ecs:${local.region}:${local.account_id}:*/*",
          "arn:aws:ec2:${local.region}:${local.account_id}:*/*",
          "arn:aws:elasticloadbalancing:${local.region}:${local.account_id}:*/*"
        ]
      },
    ]
  })
}

resource "aws_iam_policy" "ecs_elb_targets_policy" {
  name               = var.ecs_elb_targets_policy_name
  path               = "/"
  description        = "ECS ELB policy."
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "elasticloadbalancing:Describe*",
          "ecs:CreateTaskSet",
          "ecs:DeleteTaskSet",
          "ecs:DescribeServices",
          "ecs:UpdateServicePrimaryTaskSet",
          "elasticloadbalancing:DescribeListeners",
          "elasticloadbalancing:DescribeRules",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:ModifyListener",
          "elasticloadbalancing:ModifyRule"
        ]
        Effect = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_policy" "autoscaling_policy" {
  name               = var.autoscaling_policy_name
  path               = "/"
  description        = "CloudWatch policy."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecs:DescribeServices",
          "ecs:UpdateService",
          "cloudwatch:PutMetricAlarm",
          "cloudwatch:DescribeAlarms",
          "cloudwatch:DeleteAlarms"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:ecs:${local.region}:${local.account_id}:*/*",
          "arn:aws:cloudwatch:${local.region}:${local.account_id}:*/*"
        ]
      },
    ]
  })
}

resource "aws_iam_policy" "dynamo_policy" {
  name               = var.dynamo_policy_name
  path               = "/"
  description        = "DynamoDB policy."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:logs:${local.region}:${local.account_id}:*/*",
          "arn:aws:dynamodb:${local.region}:${local.account_id}:*/*"
        ]
      },
    ]
  })
}

resource "aws_iam_role" "ecs_service_role" {
  name               = var.ecs_service_role_name
  path               = "/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = ["ecs.amazonaws.com", "ec2.amazonaws.com", "ecs-tasks.amazonaws.com"]
        }
      },
    ]
  })
}

resource "aws_iam_role" "ec2_role" {
  name                = var.ec2_instance_role_name
  path                = "/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = ["ecs.amazonaws.com", "ec2.amazonaws.com", "dynamodb.amazonaws.com", "ecs-tasks.amazonaws.com"]
        }
      },
    ]
  })
}

resource "aws_iam_role" "autoscaling_role" {
  name               = var.autoscaling_role_name
  path               = "/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = ["autoscaling.amazonaws.com"]
        }
      },
    ]
  })
}

resource "aws_iam_role" "lambda_functional_test_role" {
  name               = var.lambda_functional_test_role_name
  path               = "/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = ["lambda.amazonaws.com"]
        }
      },
    ]
  })
}

resource "aws_iam_policy" "cloudformation_policy" {
  name        = var.cloudformation_policy_name
  path        = "/"
  description = "CloudFormation policy."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "cloudformation:DescribeStacks",
          "cloudformation:DescribeChangeSet",
          "cloudformation:GetTemplateSummary",
          "cloudformation:DescribeStackEvents",
          "cloudformation:CreateChangeSet",
          "cloudformation:ExecuteChangeSet",
          "cloudformation:CreateStack",
          "cloudformation:UpdateStack",
          "cloudformation:ListStackResources"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:cloudformation:${local.region}:${local.account_id}:*",
          "arn:aws:cloudformation:${local.region}:${local.account_id}:transform/*"
        ]
      },
    ]
  })
}

resource "aws_iam_policy" "lambda_test_codedeploy_policy" {
  name        = var.lambda_test_codedeploy_policy_name
  path        = "/"
  description = "My ECR policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
            "ecs:DescribeServices",
            "ecs:CreateTaskSet",
            "ecs:UpdateServicePrimaryTaskSet",
            "ecs:DeleteTaskSet",
            "elasticloadbalancing:DescribeTargetGroups",
            "elasticloadbalancing:DescribeListeners",
            "elasticloadbalancing:ModifyListener",
            "elasticloadbalancing:DescribeRules",
            "elasticloadbalancing:ModifyRule",
            "lambda:InvokeFunction",
            "cloudwatch:DescribeAlarms",
            "lambda:UpdateAlias",
            "lambda:GetAlias",
            "lambda:GetProvisionedConcurrencyConfig"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:elasticloadbalancing:${local.region}:${local.account_id}:*",
          "arn:aws:lambda:${local.region}:${local.account_id}:*",
          "arn:aws:cloudwatch:${local.region}:${local.account_id}:*",
          "arn:aws:ecs:${local.region}:${local.account_id}:*"        ]
      },
    ]
  })
}

resource "aws_iam_policy" "codedeploy_execution_status_policy" {
  name        = var.codedeploy_execution_status_policy_name
  path        = "/"
  description = "My ECR policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
            "codedeploy:PutLifecycleEventHookExecutionStatus"
        ]
        Effect = "Allow"
        Resource = "arn:aws:codedeploy:${local.region}:${local.account_id}:deploymentgroup:${var.codedeploy_demo_app_name}/${var.codedeploy_deployment_demo_group_name}"
      },
    ]
  })
}

resource "aws_iam_policy" "lambda_functional_test_policy" {
  name        = var.lambda_functional_test_policy_name
  path        = "/"
  description = "My ECR policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
            "logs:CreateLogStream",
            "logs:CreateLogGroup",
            "logs:PutLogEvents"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:logs:${local.region}:${local.account_id}:*",
          "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/lambda/${var.lambda_test_function_name}:*"
        ]
      },
    ]
  })
}

resource "aws_iam_policy" "pipeline_artifacts_s3_bucket_objects_policy" {
  name        = var.pipeline_s3_bucket_objects_policy_name
  path        = "/"
  description = "CodePipeline S3 Artifacts policy."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject*",
          "s3:PutObject*",
          "s3:GetBucketVersioning",
          "s3:GetBucketLocation",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect = "Allow"
        Resource = [
          "${aws_s3_bucket.demoBucket.arn}",
          "${aws_s3_bucket.demoBucket.arn}/*",
          "arn:aws:logs:${local.region}:${local.account_id}:*/*"
        ]
      },
    ]
  })
}

resource "aws_iam_policy" "ecr_permissions_policy" {
  name        = var.ecr_permissions_policy_name
  path        = "/"
  description = "ECR policy."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:ListImages",
          "ecr:DescribeImages",
          "ecr:DescribeRegistry",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:GetRepositoryPolicy",
          "ecr:SetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:CreateRepository"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:ecr:${local.region}:${local.account_id}:repository/*"
      },
    ]
  })
}

resource "aws_iam_policy" "code_pipeline_base_policy" {
  name        = var.code_pipeline_base_policy_name
  path        = "/"
  description = "CodeCommit policy."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "codepipeline:List*",
          "codepipeline:Get*",
          "codepipeline:List*",
          "codepipeline:StartPipelineExecution",
          "codepipeline:StopPipelineExecution",
          "codepipeline:RetryStageExecution",
          "codepipeline:UpdatePipeline",
          "codepipeline:CreatePipeline",
          "codepipeline:DeletePipeline",
          "codepipeline:TagResource",
          "codepipeline:UntagResource",
          "codepipeline:EnableStageTransition",
          "codepipeline:DisableStageTransition",
          "codepipeline:PollForJobs",
          "codepipeline:PutActionRevision",
          "codepipeline:PutApprovalResult",
          "codepipeline:PutJobFailureResult",
          "codepipeline:PutJobSuccessResult",
          "codebuild:StartBuild",
          "codebuild:BatchGetBuilds",
          "codecommit:GetBranch",
          "codecommit:GetCommit",
          "codecommit:UploadArchive",
          "codecommit:GetUploadArchiveStatus",
          "codecommit:GitPull",
          "codecommit:GitPush",
          "codecommit:GetRepository"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:codebuild:${local.region}:${local.account_id}:*/*",
          "arn:aws:codepipeline:${local.region}:${local.account_id}:*/*",
          "${local.codecommit_repo_arn}"
        ]
      },
    ]
  })
}

resource "aws_iam_policy" "codedeploy_lb_ecs_policy" {
  name        = var.codedeploy_lb_ecs_policy_name
  path        = "/"
  description = "Code deploy ECS and Load Balancing policy."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:ListImages",
          "ecr:DescribeImages",
          "ecr:DescribeRegistry",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:GetRepositoryPolicy",
          "ecr:SetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:CreateRepository"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_policy" "codedeploy_s3_bucket_objects_policy" {
  name        = var.codedeploy_s3_bucket_objects_policy_name
  path        = "/"
  description = "CodePipeline S3 Artifacts policy."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject*"
        ]
        Effect = "Allow"
        Resource = [
          "${aws_s3_bucket.demoBucket.arn}",
          "${aws_s3_bucket.demoBucket.arn}/*"
        ]
      },
    ]
  })
}

resource "aws_iam_policy" "codepipeline_codedeploy_policy" {
  name        = var.codepipeline_codedeploy_policy_name
  path        = "/"
  description = "CodePipeline CodeDeploy Artifacts policy."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "codedeploy:GetApplication",
          "codedeploy:GetApplicationRevision",
          "codedeploy:RegisterApplicationRevision",
          "codedeploy:CreateDeployment",
          "codedeploy:GetDeploymentConfig",
          "codedeploy:GetDeployment"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:codedeploy:${local.region}:${local.account_id}:application:${var.codedeploy_demo_app_name}",
          "arn:aws:codedeploy:${local.region}:${local.account_id}:deploymentgroup:${var.codedeploy_demo_app_name}/${var.codedeploy_deployment_demo_group_name}",
          "arn:aws:codedeploy:${local.region}:${local.account_id}:deploymentconfig:CodeDeployDefault.ECSAllAtOnce"
        ]
      },
    ]
  })
}

resource "aws_iam_policy" "session_manager_policy" {
  name        = var.session_manager_policy_name
  path        = "/"
  description = "Session Manager policy."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:DescribeAssociation",
          "ssm:GetDeployablePatchSnapshotForInstance",
          "ssm:GetDocument",
          "ssm:DescribeDocument",
          "ssm:GetManifest",
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:ListAssociations",
          "ssm:ListInstanceAssociations",
          "ssm:PutInventory",
          "ssm:PutComplianceItems",
          "ssm:PutConfigurePackageResult",
          "ssm:UpdateAssociationStatus",
          "ssm:UpdateInstanceAssociationStatus",
          "ssm:UpdateInstanceInformation",
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel",
          "ec2messages:AcknowledgeMessage",
          "ec2messages:DeleteMessage",
          "ec2messages:FailMessage",
          "ec2messages:GetEndpoint",
          "ec2messages:GetMessages",
          "ec2messages:SendReply"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:ec2:${local.region}:${local.account_id}:*/*",
          "arn:aws:ssm:${local.region}:${local.account_id}:*/*"
        ]
      },
    ]
  })
}

resource "aws_iam_policy" "codedeploy_pass_role_policy" {
  name        = var.codedeploy_pass_role_policy_name
  path        = "/"
  description = "CodePipeline S3 Artifacts policy."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "iam:PassRole"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:codebuild:us-east-1:${local.region}:flask-codebuild-project",
          "arn:aws:codebuild:us-east-1:${local.region}:${var.codedeploy_deployment_demo_group_name}"
        ]
      },
    ]
  })
}

resource "aws_iam_role" "lambda_build_role" {
  name        = var.lambda_build_role_name
  description = "This role will build and deploy lambda functions from CodePipeline."
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = ["lambda.amazonaws.com", "codepipeline.amazonaws.com", "codebuild.amazonaws.com"]
        }
      },
    ]
  })
}

resource "aws_iam_role" "code_pipeline_service_role" {
  name        = var.code_pipeline_service_role_name
  description = "This role will build and deploy lambda functions from CodePipeline."
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = ["codepipeline.amazonaws.com", "codebuild.amazonaws.com", "codedeploy.amazonaws.com"]
        }
      },
    ]
  })
}

resource "aws_iam_role" "code_deploy_service_role" {
  name        = var.code_deploy_service_role_name
  description = "This role will build enable CodeDeploy to manage our ECS apps."
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = ["codedeploy.amazonaws.com"]
        }
      },
    ]
  })
}

resource "aws_iam_role" "code_build_pipeline_role" {
  name = "code_build_pipeline_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = [
            "codepipeline.amazonaws.com",
            "codebuild.amazonaws.com",
          ]
        }
      },
    ]
  })
}

resource "aws_iam_role" "lambda_execution_role" {
  name        = "lambda_execution_role"
  description = "This role will enable Lambda functions to execute."
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}



resource "aws_iam_policy" "cloud_watch_events_policy" {
  name        = "cloud_watch_events_policy"
  path        = "/"
  description = "CloudWatch Events policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "codepipeline:StartPipelineExecution"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:codepipeline:${local.region}:${local.account_id}:${var.code_pipeline_name}"
        ]
      },
    ]
  })
}

resource "aws_iam_role" "pipeline_cloudwatch_events_role" {
  name        = "pipeline_cloudwatch_events_role"
  description = "This role will triggle the pipeline whenever there is commit to specified branch."
  managed_policy_arns = [
    aws_iam_policy.cloud_watch_events_policy.arn
  ]
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "events.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_cloudwatch_event_rule" "pipeline_event_rule" {
  name          = "pipeline-event-trigger"
  description   = "Capture each AWS Console Sign In"
  event_pattern = <<EOF
  {
  "detail-type": [
    "CodeCommit Repository State Change"
  ],
  "source": [
    "aws.codecommit"
  ],
  "resources": [
    "${local.codecommit_repo_arn}"
  ],
  "detail": {
    "referenceType": [
      "branch"
    ],
    "referenceName": [
      "main"
    ],
    "event": [
      "referenceCreated",
      "referenceUpdated"
    ]
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "pipeline_target" {
  target_id = "codepipeline"
  rule      = aws_cloudwatch_event_rule.pipeline_event_rule.name
  arn       = "arn:aws:codepipeline:${local.region}:${local.account_id}:${var.code_pipeline_name}"
  role_arn  = aws_iam_role.pipeline_cloudwatch_events_role.arn
}


resource "aws_iam_policy" "iam_pass_role_policy" {
  name        = var.iam_pass_role_policy_name
  path        = "/"
  description = "My ECR policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "iam:PassRole",
          "iam:GetRole"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:codebuild:${local.region}:${local.account_id}:${var.code_build_project_name}/*",
          "${aws_iam_role.lambda_execution_role.arn}"
        ]
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_service_role_attachment" {
  depends_on = [
    aws_iam_policy.ecs_load_balancing_policy,
    aws_iam_policy.ecs_policy,
    aws_iam_policy.ecr_policy,
    aws_iam_policy.ecs_elb_targets_policy
  ]
  for_each = toset([
    "arn:aws:iam::${local.account_id}:policy/${var.ecs_load_balancing_policy_name}",
    "arn:aws:iam::${local.account_id}:policy/${var.ecs_policy_name}",
    "arn:aws:iam::${local.account_id}:policy/${var.ecr_policy_name}",
    "arn:aws:iam::${local.account_id}:policy/${var.ecs_elb_targets_policy_name}"
  ])
  role       = aws_iam_role.ecs_service_role.name
  policy_arn = each.value
}

resource "aws_iam_role_policy_attachment" "ec2_role_attachment" {
  depends_on = [
    aws_iam_policy.ecr_policy,
    aws_iam_policy.dynamo_policy,
    aws_iam_policy.ecs_policy,
    aws_iam_policy.ecr_policy,
    aws_iam_policy.session_manager_policy
  ]
  for_each = toset([
    "arn:aws:iam::${local.account_id}:policy/${var.ecr_policy_name}",
    "arn:aws:iam::${local.account_id}:policy/${var.dynamo_policy_name}",
    "arn:aws:iam::${local.account_id}:policy/${var.ecs_policy_name}",
    "arn:aws:iam::${local.account_id}:policy/${var.ecr_policy_name}",
    "arn:aws:iam::${local.account_id}:policy/${var.session_manager_policy_name}"
  ])
  role       = aws_iam_role.ec2_role.name
  policy_arn = each.value
}

resource "aws_iam_role_policy_attachment" "autoscaling_role_attachment" {
  depends_on = [
    aws_iam_policy.autoscaling_policy
  ]
  for_each = toset([
    "arn:aws:iam::${local.account_id}:policy/${var.autoscaling_policy_name}"
  ])
  role       = aws_iam_role.autoscaling_role.name
  policy_arn = each.value
}

resource "aws_iam_role_policy_attachment" "lambda_build_role_attachment" {
  depends_on = [
    aws_iam_policy.iam_pass_role_policy,
    aws_iam_policy.cloud_watch_events_policy,
    aws_iam_policy.code_pipeline_base_policy,
    aws_iam_policy.ecr_permissions_policy,
    aws_iam_policy.pipeline_artifacts_s3_bucket_objects_policy,
    aws_iam_policy.cloudformation_policy,
    aws_iam_policy.ecr_policy
  ]
  for_each = toset([
    "arn:aws:iam::${local.account_id}:policy/${var.code_pipeline_base_policy_name}",
    "arn:aws:iam::${local.account_id}:policy/${var.iam_pass_role_policy_name}",
    "arn:aws:iam::${local.account_id}:policy/${var.ecr_permissions_policy_name}",
    "arn:aws:iam::${local.account_id}:policy/${var.pipeline_s3_bucket_objects_policy_name}",
    "arn:aws:iam::${local.account_id}:policy/${var.cloudformation_policy_name}",
    "arn:aws:iam::${local.account_id}:policy/${var.ecr_policy_name}"
  ])
  role       = aws_iam_role.lambda_build_role.name
  policy_arn = each.value
}

resource "aws_iam_role_policy_attachment" "code_build_pipeline_role_attachment" {
  depends_on = [
    aws_iam_policy.iam_pass_role_policy,
    aws_iam_policy.cloud_watch_events_policy,
    aws_iam_policy.code_pipeline_base_policy,
    aws_iam_policy.ecr_permissions_policy,
    aws_iam_policy.pipeline_artifacts_s3_bucket_objects_policy,
    aws_iam_policy.cloudformation_policy,
    aws_iam_policy.ecr_policy
  ]
  for_each = toset([
    "arn:aws:iam::${local.account_id}:policy/${var.code_pipeline_base_policy_name}",
    "arn:aws:iam::${local.account_id}:policy/${var.iam_pass_role_policy_name}",
    "arn:aws:iam::${local.account_id}:policy/${var.ecr_permissions_policy_name}",
    "arn:aws:iam::${local.account_id}:policy/${var.pipeline_s3_bucket_objects_policy_name}",
    "arn:aws:iam::${local.account_id}:policy/${var.cloudformation_policy_name}",
    "arn:aws:iam::${local.account_id}:policy/${var.ecr_policy_name}"
  ])
  role       = aws_iam_role.code_build_pipeline_role.name
  policy_arn = each.value
}

resource "aws_iam_role_policy_attachment" "attach_lambda_execution_role_attachment" {
  depends_on = [
    aws_iam_policy.iam_pass_role_policy,
    aws_iam_policy.cloud_watch_events_policy,
    aws_iam_policy.code_pipeline_base_policy,
    aws_iam_policy.ecr_permissions_policy,
    aws_iam_policy.pipeline_artifacts_s3_bucket_objects_policy,
    aws_iam_policy.cloudformation_policy,
    aws_iam_policy.ecr_policy
  ]
  for_each = toset([
    "arn:aws:iam::${local.account_id}:policy/${var.pipeline_s3_bucket_objects_policy_name}",
    "arn:aws:iam::${local.account_id}:policy/${var.iam_pass_role_policy_name}"
  ])
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = each.value
}

resource "aws_iam_role_policy_attachment" "code_pipeline_service_role_attachment" {
  depends_on = [
    aws_iam_policy.iam_pass_role_policy,
    aws_iam_policy.cloud_watch_events_policy,
    aws_iam_policy.code_pipeline_base_policy,
    aws_iam_policy.ecr_permissions_policy,
    aws_iam_policy.pipeline_artifacts_s3_bucket_objects_policy,
    aws_iam_policy.ecr_policy,
    aws_iam_policy.codepipeline_codedeploy_policy
  ]
  for_each = toset([
    "arn:aws:iam::${local.account_id}:policy/${var.ecr_permissions_policy_name}",
    "arn:aws:iam::${local.account_id}:policy/${var.pipeline_s3_bucket_objects_policy_name}",
    "arn:aws:iam::${local.account_id}:policy/${var.cloudformation_policy_name}",
    "arn:aws:iam::${local.account_id}:policy/${var.iam_pass_role_policy_name}",
    "arn:aws:iam::${local.account_id}:policy/${var.code_pipeline_base_policy_name}",
    "arn:aws:iam::${local.account_id}:policy/${var.ecr_policy_name}",
    "arn:aws:iam::${local.account_id}:policy/${var.codepipeline_codedeploy_policy_name}"
  ])
  role       = aws_iam_role.code_pipeline_service_role.name
  policy_arn = each.value
}

resource "aws_iam_role_policy_attachment" "code_deploy_service_role_attachment" {
  depends_on = [
    aws_iam_policy.codedeploy_lb_ecs_policy,
    aws_iam_policy.codedeploy_s3_bucket_objects_policy,
    aws_iam_policy.codedeploy_pass_role_policy,
    aws_iam_policy.ecs_policy,
    aws_iam_policy.lambda_test_codedeploy_policy,
    aws_iam_policy.ecs_elb_targets_policy
  ]
  for_each = toset([
    "arn:aws:iam::${local.account_id}:policy/${var.codedeploy_lb_ecs_policy_name}",
    "arn:aws:iam::${local.account_id}:policy/${var.codedeploy_s3_bucket_objects_policy_name}",
    "arn:aws:iam::${local.account_id}:policy/${var.codedeploy_pass_role_policy_name}",
    "arn:aws:iam::${local.account_id}:policy/${var.ecs_policy_name}",
    "arn:aws:iam::${local.account_id}:policy/${var.lambda_test_codedeploy_policy_name}",
    "arn:aws:iam::${local.account_id}:policy/${var.ecs_elb_targets_policy_name}"
  ])
  role       = aws_iam_role.code_deploy_service_role.name
  policy_arn = each.value
}

resource "aws_iam_role_policy_attachment" "test_lambda_service_role_attachment" {
  depends_on = [
    aws_iam_policy.lambda_functional_test_policy,
    aws_iam_policy.codedeploy_execution_status_policy
  ]
  for_each = toset([
    "arn:aws:iam::${local.account_id}:policy/${var.lambda_functional_test_policy_name}",
    "arn:aws:iam::${local.account_id}:policy/${var.codedeploy_execution_status_policy_name}"
  ])
  role       = aws_iam_role.lambda_functional_test_role.name
  policy_arn = each.value
}