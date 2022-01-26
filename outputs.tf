output "iam_role" {
  value = aws_iam_role.this
}

output "workspaces_directory" {
  value = aws_workspaces_directory.this
}

output "workspaces_workspace" {
  value = aws_workspaces_workspace.this
}

output "security_group" {
  value = aws_security_group.this
}

output "kms_key" {
  value = aws_kms_key.this
}

