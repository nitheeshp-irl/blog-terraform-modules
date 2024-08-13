variable "organizational_units" {
  description = "List of organizational units"
  type = list(object({
    unit_name = string
  }))
}

variable "parent_id" {
  description = "The parent ID for the organizational units"
  type        = string
}