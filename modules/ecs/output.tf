output "ecs_cluster_id" {
  value = aws_ecs_cluster.ecs_cluster.id
}

output "execution_role_arn" {
   value = aws_iam_role.ecs_task_execution_role.arn
  }

