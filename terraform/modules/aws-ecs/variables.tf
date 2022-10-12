variable "vpc" {
  description = "ECS Cluster Name"
  type        = string
}

variable "public_subnet_1" {
  description = "Public Subnet 1"
  type        = string
}

variable "public_subnet_2" {
  description = "Public Subnet 2"
  type        = string
}

variable "region" {
  description = "Region"
  type        = string
}

variable "private_subnet_1" {
  description = "Private Subnet 1"
  type        = string
}

variable "private_subnet_2" {
  description = "Private Subnet 2"
  type        = string
}

variable "ecs_service_role_arn" {
  description = "ECS Service Role ARN"
  type        = string
}

variable "ec2_role_name" {
  description = "EC2 Role Name"
  type        = string
}

variable "autoscaling_role_arn" {
  description = "ASG Role ARN"
  type        = string
}

variable "ecs_service_name" {
  description = "ECS Service Name"
  type        = string
  default     = "demo-flask-service"
}

variable "ecs_desired_capacity" {
  description = "ECS desire capacity"
  type        = string
  default     = "4"
}

variable "ecs_maximum_capacity" {
  description = "ECS maximum capacity"
  type        = string
  default     = "15"
}

variable "ecs_minimum_capacity" {
  description = "ECS minimum capacity"
  type        = string
  default     = "1"
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t2.medium"
}

variable "asg_scaling_adjustment" {
  description = "ASG scaling adjustment"
  type        = string
  default     = "1"
}

variable "asg_adjustment_type" {
  description = "ASG adjustment policy"
  type        = string
  default     = "ChangeInCapacity"
}

variable "ecs_infra_scale_out_policy" {
  description = "ECS Infra scale out policy"
  type        = string
  default     = "ecs_infra_scale_out_policy"
}

variable "ecs_autoscaling_target_namespace" {
  description = "ECS autoscaling target service namespace"
  type        = string
  default     = "ecs"
}

variable "ecs_asg_policy_name" {
  description = "ECS ASG policy name"
  type        = string
  default     = "ecs_infra_scale_out_policy"
}

variable "ecs_asg_name" {
  description = "ECS ASG name"
  type        = string
  default     = "ecs-asg"
}

variable "aws_ecs_service_launch_type" {
  description = "ECS Service launch type"
  type        = string
  default     = "EC2"
}

variable "aws_ecs_service_deployment_controller" {
  description = "ECS Service deployment controller"
  type        = string
  default     = "CODE_DEPLOY"
}

variable "ecs_cluster_name" {
  description = "ECS Cluster name"
  type        = string
  default     = "demo-ecs-cluster"
}

variable "flask_ecs_service_container_name" {
  description = "Flask ECS Service container name"
  type        = string
  default     = "flask-docker-demo-app"
}

variable "flask_ecs_service_container_port" {
  description = "Flask ECS Service container port"
  type        = string
  default     = "5000"
}

variable "flask_ecs_blue_tg_name" {
  description = "Flask ECS Blue TG name"
  type        = string
  default     = "demo-app-blue-tg"
}

variable "flask_ecs_green_tg_name" {
  description = "Flask ECS Green TG name"
  type        = string
  default     = "demo-app-green-tg"
}

variable "ecr_repo_url" {
  description = "The desired ECR image URL."
  type        = string
}

variable "ecs_sg_name" {
  description = "ECS security group name"
  type        = string
  default     = "ecs-sg"
}

variable "scalable_dimension" {
  description = "ASG target scaling dimension."
  type        = string
  default     = "ecs:service:DesiredCount"
}

variable "flask_container_name" {
  description = "ECS Flask App container name"
  type        = string
  default     = "flask-docker-demo-app"
}

variable "dynamodb_table_name" {
  description = "DynamoDB table name"
  type        = string
  default     = "musicTable"  
}

variable "dynamodb_billing_mode" {
  description = "DynamoDB billing mode"
  type        = string
  default     = "PROVISIONED"  
}

variable "dynamodb_read_capacity" {
  description = "DynamoDB read capacity"
  type        = number
  default     = 1  
}

variable "dynamodb_write_capacity" {
  description = "DynamoDB write capacity"
  type        = number
  default     = 1  
}

variable "dynamodb_hash_key" {
  description = "DynamoDB hash key"
  type        = string
  default     = "artist" 
}

variable "dynamodb_attribute_name" {
  description = "DynamoDB attribute name"
  type        = string
  default     = "artist" 
}

variable "dynamodb_attribute_type" {
  description = "DynamoDB attribute type"
  type        = string
  default     = "S" 
}

variable "ecs_task_cw_logs_group_name" {
  description = "ECS CW logs group name."
  type        = string
  default     = "ecs-logs"
}

variable "ecs_cw_retention_days" {
  description = "ECS CW logs group name."
  type        = number
  default     = 14
}

variable "ecs_lb_tg_timeout" {
  description = "ECS Load Balancer target group timeout"
  type        = number
  default     = 2
}

variable "ecs_lb_tg_interval" {
  description = "ECS Load Balancer listener port"
  type        = number
  default     = 10  
}

variable "ecs_lb_tg_matcher" {
  description = "ECS Load Balancer target group matcher"
  type        = string
  default     = "200"  
}

variable "ecs_lb_listener_action_type" {
  description = "ECS Load Balancer action type"
  type        = string
  default     = "forward"  
}

variable "ecs_tg_protocol" {
  description = "ECS target group protocol"
  type        = string
  default     = "HTTP"  
}

variable "ecs_tg_type" {
  description = "ECS target type"
  type        = string
  default     = "instance"  
}

variable "ecs_alb_name" {
  description = "ECS ALB name"
  type        = string
  default     = "ecsalb"  
}

variable "ecs_lb_type" {
  description = "ECS Load Balancer type"
  type        = string
  default     = "application"  
}

variable "ecs_alb_timeout" {
  description = "ECS Load Balancer type"
  type        = number
  default     = 30  
}

variable "ecs_alb_listener_port" {
  description = "ECS Load Balancer listener port"
  type        = number
  default     = 80  
}

variable "ecs_alb_test_listener_port" {
  description = "ECS Load Balancer test listener port"
  type        = number
  default     = 8080  
}

variable "ecs_lb_tg_healthy_threshold" {
  description = "ECS Load Balancer target group healthy threshold"
  type        = number
  default     = 2
}

variable "ecs_lb_tg_unhealthy_threshold" {
  description = "ECS Load Balancer target group unhealthy threshold"
  type        = number
  default     = 2
}

variable "ecs_task_network_mode" {
  description = "ECS task network mode"
  type        = string
  default     = "bridge"  
}

variable "ecs_task_logs_driver" {
  description = "ECS task logs driver"
  type        = string
  default     = "awslogs"  
}

variable "ecs_task_memory" {
  description = "ECS task memory"
  type        = number
  default     = 300  
}

variable "ecs_task_cpu" {
  description = "ECS task cpu"
  type        = number
  default     = 10  
}

variable "ecs_mp_container_path" {
  description = "ECS task mount point container path"
  type        = string
  default     = "/usr/local/apache2/htdocs"  
}

variable "ecs_mp_source_volume" {
  description = "ECS mount point source volume"
  type        = string
  default     = "my-vol"  
}

variable "ecs_task_container_port" {
  description = "ECS task container port"
  type        = number
  default     = 5000  
}

variable "ecs_task_cw_logs_prefix" {
  description = "ECS task CloudWatch group prefix"
  type        = string
  default     = "flask-docker-demo-app"  
}

variable "ec2_instance_profile_name" {
  description = "ECS Instance Profile name"
  type        = string
  default     = "ecs_ec2_instance_profile"
}