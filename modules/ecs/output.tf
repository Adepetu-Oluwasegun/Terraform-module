output "ecs_cluster_id" {
  value = aws_ecs_cluster.ecs_cluster.id
}

output "name" {
  value = aws_ecs_task_definition.ecs_task_definition.arn
}