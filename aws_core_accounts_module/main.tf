resource "aws_organizations_account" "logging_account" {
  name  = var.logging_account_name
  email = var.logging_account_email
}

resource "aws_organizations_account" "security_account" {
  name  = var.security_account_name
  email = var.security_account_email
}