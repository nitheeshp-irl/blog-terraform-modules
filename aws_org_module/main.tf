resource "aws_organizations_organizational_unit" "example" {
  for_each = { for ou in var.organizational_units : ou.unit_name => ou }

  name      = each.key
  parent_id = var.parent_id
}