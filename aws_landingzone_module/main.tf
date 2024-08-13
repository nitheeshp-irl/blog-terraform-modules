provider "aws" {
  region = var.region
}

data "aws_partition" "current" {}

resource "aws_iam_role" "aws_control_tower_admin" {
  name = "AWSControlTowerAdmin"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = {
        Service = "controltower.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  path = "/service-role/"
}

resource "aws_iam_role_policy_attachment" "aws_control_tower_admin_policy_attachment" {
  role       = aws_iam_role.aws_control_tower_admin.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSControlTowerServiceRolePolicy"
}

resource "aws_iam_policy" "aws_control_tower_admin_policy" {
  name = "AWSControlTowerAdminPolicy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "ec2:DescribeAvailabilityZones"
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "aws_control_tower_admin_custom_policy_attachment" {
  role       = aws_iam_role.aws_control_tower_admin.name
  policy_arn = aws_iam_policy.aws_control_tower_admin_policy.arn
}

resource "aws_iam_role" "aws_control_tower_cloud_trail_role" {
  name = "AWSControlTowerCloudTrailRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = {
        Service = "cloudtrail.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  path = "/service-role/"
}

resource "aws_iam_policy" "aws_control_tower_cloud_trail_role_policy" {
  name = "AWSControlTowerCloudTrailRolePolicy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["logs:CreateLogStream", "logs:PutLogEvents"]
      Resource = "arn:aws:logs:*:*:log-group:aws-controltower/CloudTrailLogs:*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "aws_control_tower_cloud_trail_role_policy_attachment" {
  role       = aws_iam_role.aws_control_tower_cloud_trail_role.name
  policy_arn = aws_iam_policy.aws_control_tower_cloud_trail_role_policy.arn
}

resource "aws_iam_role" "aws_control_tower_config_aggregator_role_for_organizations" {
  name = "AWSControlTowerConfigAggregatorRoleForOrganizations"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = {
        Service = "config.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  path = "/service-role/"
}

resource "aws_iam_role_policy_attachment" "aws_control_tower_config_aggregator_role_policy_attachment" {
  role       = aws_iam_role.aws_control_tower_config_aggregator_role_for_organizations.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRoleForOrganizations"
}

resource "aws_iam_role" "aws_control_tower_stack_set_role" {
  name = "AWSControlTowerStackSetRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = {
        Service = "cloudformation.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  path = "/service-role/"
}

resource "aws_iam_policy" "aws_control_tower_stack_set_role_policy" {
  name = "AWSControlTowerStackSetRolePolicy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "sts:AssumeRole"
      Resource = "arn:aws:iam::*:role/AWSControlTowerExecution"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "aws_control_tower_stack_set_role_policy_attachment" {
  role       = aws_iam_role.aws_control_tower_stack_set_role.name
  policy_arn = aws_iam_policy.aws_control_tower_stack_set_role_policy.arn
}

resource "aws_iam_role" "execution_role" {
  name = "AWSControlTowerExecution"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        AWS = var.administrator_account_id
      },
      Action = "sts:AssumeRole"
    }]
  })
  path = "/"
}

resource "aws_iam_role_policy_attachment" "execution_role_policy_attachment" {
  role       = aws_iam_role.execution_role.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AdministratorAccess"
}

resource "aws_controltower_landing_zone" "example" {
  manifest_json = var.manifest_json
  version       = var.landingzone_version

  depends_on = [
    aws_iam_role.aws_control_tower_admin,
    aws_iam_role_policy_attachment.aws_control_tower_admin_policy_attachment,
    aws_iam_role_policy_attachment.aws_control_tower_admin_custom_policy_attachment
  ]
}