# need it to reference ecs container when setting it up
output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_tasks_execution_role.arn
}