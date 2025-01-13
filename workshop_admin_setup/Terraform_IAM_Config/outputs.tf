# output the arn of the github actions role
output "github_actions_role_arn" {
  value = aws_iam_role.github_actions_role.arn
}
