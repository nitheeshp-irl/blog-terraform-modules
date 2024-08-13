output "log_account_id" {
  value = aws_organizations_account.logging_account.id
}

output "security_account_id" {
  value = aws_organizations_account.security_account.id
}
