variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-2"
}

variable "administrator_account_id" {
  description = "AWS Account Id of the administrator account (the account in which StackSets will be created)"
  type        = string
  validation {
    condition     = length(var.administrator_account_id) == 12
    error_message = "The administrator account ID must be exactly 12 characters long."
  }
}

variable "manifest_json" {
  description = "The manifest JSON for the AWS Control Tower landing zone"
  type        = string
}

variable "landingzone_version" {
  description = "The version of the AWS Control Tower landing zone"
  type        = string
}