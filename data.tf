data "aws_caller_identity" "current" {}

data "aws_organizations_organization" "current" {}

data "aws_iam_policy" "iam_readonly_access" {
  arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

data "nops_projects" "current" {}
