# Create a security group for the ALB.
resource "aws_security_group" "ecs_sg" {
  name        = var.ecs_sg_name
  description = "ECS security group for the ALB."
  vpc_id      = var.vpc

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 8080
    to_port     = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol  = "tcp"
    from_port = 31000
    to_port   = 61000
    self      = true
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a CloudWatch log group.
resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = var.ecs_task_cw_logs_group_name
  retention_in_days = var.ecs_cw_retention_days
}

# Create an ECS task definition.
resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                = "${var.ecs_service_name}-ecs-demo-app"
  network_mode          = var.ecs_task_network_mode
  requires_compatibilities = ["EC2"]
  container_definitions = <<DEFINITION
[
  {
    "name": "${var.flask_container_name}",
    "cpu": ${var.ecs_task_cpu},
    "image": "${var.ecr_repo_url}:latest",
    "essential": true,
    "memory": ${var.ecs_task_memory},
    "logConfiguration": {
      "logDriver": "${var.ecs_task_logs_driver}",
      "options": {
        "awslogs-group": "${var.ecs_task_cw_logs_group_name}",
        "awslogs-region": "${var.region}",
        "awslogs-stream-prefix": "${var.ecs_task_cw_logs_prefix}"
      }
    },
    "mountPoints": [
      {
        "containerPath": "${var.ecs_mp_container_path}",
        "sourceVolume": "${var.ecs_mp_source_volume}"
      }
    ],
    "portMappings": [
      {
        "containerPort": ${var.ecs_task_container_port}
      }
    ]
  }
]
DEFINITION
  volume {
    name = "${var.ecs_mp_source_volume}"
  }
}

# Create the Application Load Balancer.
resource "aws_lb" "main" {
  name                       = var.ecs_alb_name
  internal                   = false
  load_balancer_type         = var.ecs_lb_type
  security_groups            = [aws_security_group.ecs_sg.id]
  subnets                    = [var.public_subnet_1, var.public_subnet_2]
  idle_timeout               = var.ecs_alb_timeout
  enable_deletion_protection = false
}

# Create the ALB target group.
resource "aws_lb_target_group" "ecs_rest_api_tg_green" {
  name        = var.flask_ecs_green_tg_name
  port        = var.ecs_alb_listener_port
  protocol    = var.ecs_tg_protocol
  vpc_id      = var.vpc
  target_type = var.ecs_tg_type
  health_check {
    path                = "/"
    protocol            = "${var.ecs_tg_protocol}"
    healthy_threshold   = var.ecs_lb_tg_healthy_threshold
    unhealthy_threshold = var.ecs_lb_tg_unhealthy_threshold
    timeout             = var.ecs_lb_tg_timeout
    interval            = var.ecs_lb_tg_interval
    matcher             = "${var.ecs_lb_tg_matcher}"
  }
}

resource "aws_lb_target_group" "ecs_rest_api_tg_blue" {
  name        = var.flask_ecs_blue_tg_name
  port        = var.ecs_alb_test_listener_port
  protocol    = var.ecs_tg_protocol
  vpc_id      = var.vpc
  target_type = var.ecs_tg_type
  health_check {
    path                = "/"
    protocol            = "${var.ecs_tg_protocol}"
    healthy_threshold   = var.ecs_lb_tg_healthy_threshold
    unhealthy_threshold = var.ecs_lb_tg_unhealthy_threshold
    timeout             = var.ecs_lb_tg_timeout
    interval            = var.ecs_lb_tg_interval
    matcher             = "${var.ecs_lb_tg_matcher}"
  }
}

# Create the ALB listener.
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.main.arn
  port              = var.ecs_alb_listener_port
  protocol          = var.ecs_tg_protocol
  default_action {
    target_group_arn = aws_lb_target_group.ecs_rest_api_tg_blue.arn
    type             = var.ecs_lb_listener_action_type
  }
  lifecycle {
    ignore_changes = [default_action]
  }
}

# Create the test ALB listener.
resource "aws_lb_listener" "alb_test_listener" {
  load_balancer_arn = aws_lb.main.arn
  port              = var.ecs_alb_test_listener_port
  protocol          = var.ecs_tg_protocol
  default_action {
    target_group_arn = aws_lb_target_group.ecs_rest_api_tg_green.arn
    type             = var.ecs_lb_listener_action_type
  }
  lifecycle {
    ignore_changes = [default_action]
  }
}

# Create the ECS cluster.
resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.ecs_cluster_name
}

# Create the ECS service.
resource "aws_ecs_service" "service" {
  name            = var.ecs_service_name
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = var.ecs_desired_capacity
  depends_on      = [aws_lb_listener.alb_listener]
  launch_type     = var.aws_ecs_service_launch_type
  deployment_controller {
    type = "${var.aws_ecs_service_deployment_controller}"
  }

  lifecycle {
    ignore_changes = [
      load_balancer,
      desired_count,
      task_definition,
    ]
  }

  load_balancer {
    container_name   = var.flask_ecs_service_container_name
    container_port   = var.flask_ecs_service_container_port
    target_group_arn = aws_lb_target_group.ecs_rest_api_tg_blue.arn
  }
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = var.ec2_instance_profile_name
  role = var.ec2_role_name
}

# Create an EC2 Launch Configuration for the ECS cluster.
resource "aws_launch_configuration" "ecs_launch_config" {
  image_id             = data.aws_ami.latest_ecs_ami.image_id
  security_groups      = [aws_security_group.ecs_sg.id]
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  user_data            = "#!/bin/bash\necho ECS_CLUSTER=demo-ecs-cluster >> /etc/ecs/ecs.config"
}

# Create the ECS autoscaling group.
resource "aws_autoscaling_group" "ecs_asg" {
  name                 = var.ecs_asg_name
  vpc_zone_identifier  = [var.private_subnet_1, var.private_subnet_2]
  launch_configuration = aws_launch_configuration.ecs_launch_config.name
  desired_capacity     = var.ecs_desired_capacity
  min_size             = var.ecs_minimum_capacity
  max_size             = var.ecs_maximum_capacity
}

# Create an autoscaling policy.
resource "aws_autoscaling_policy" "ecs_infra_scale_out_policy" {
  name                   = var.ecs_asg_policy_name
  scaling_adjustment     = var.asg_scaling_adjustment
  adjustment_type        = var.asg_adjustment_type
  autoscaling_group_name = aws_autoscaling_group.ecs_asg.name
}

# Create an application autoscaling target.
resource "aws_appautoscaling_target" "ecs_service_scaling_target" {
  max_capacity       = var.ecs_maximum_capacity
  min_capacity       = var.ecs_minimum_capacity
  resource_id        = "service/${aws_ecs_cluster.ecs_cluster.name}/${var.ecs_service_name}"
  role_arn           = var.autoscaling_role_arn
  scalable_dimension = var.scalable_dimension
  service_namespace  = var.ecs_autoscaling_target_namespace
  depends_on         = [aws_ecs_service.service]
  lifecycle {
    ignore_changes = [
      role_arn,
    ]
  }
}

resource "aws_dynamodb_table" "music_table" {
  name           = var.dynamodb_table_name
  billing_mode   = var.dynamodb_billing_mode
  read_capacity  = var.dynamodb_read_capacity
  write_capacity = var.dynamodb_write_capacity
  hash_key       = var.dynamodb_hash_key

  attribute {
    name = var.dynamodb_attribute_name
    type = var.dynamodb_attribute_type
  }
}