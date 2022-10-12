output "ecs_cluster_name" {
  value = aws_ecs_cluster.ecs_cluster.name
}

output "aws_ecs_service_name" {
  value = aws_ecs_service.service.name
}

output "aws_lb_listener_arn" {
  value = aws_lb_listener.alb_listener.arn
}

output "aws_lb_test_listener_arn" {
  value = aws_lb_listener.alb_test_listener.arn
}

output "aws_lb_dns_name" {
  value = aws_lb.main.dns_name
}

output "ecs_rest_api_tg_blue_name" {
  value = aws_lb_target_group.ecs_rest_api_tg_blue.name
}

output "ecs_rest_api_tg_green_name" {
  value = aws_lb_target_group.ecs_rest_api_tg_green.name
}

output "flask_container_name" {
  value = var.flask_container_name
}

output "ecs_sg_id" {
  value = aws_security_group.ecs_sg.id
}

output "ecs_task_definition_arn" {
  value = aws_ecs_task_definition.ecs_task_definition.arn
}