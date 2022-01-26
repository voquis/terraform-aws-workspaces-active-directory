# ---------------------------------------------------------------------------------------------------------------------
# Create an IAM role that may be assumed via STS by workspace virtual desktops
# The role will later have additional permission policies attached.
# Provider docs https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_role" "this" {
  name               = "workspaces_role"
  assume_role_policy = data.aws_iam_policy_document.assume.json
}

# Policy document to allow workspace virtual desktops to assume a role via STS
data "aws_iam_policy_document" "assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["workspaces.amazonaws.com"]
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Attach Amazon-managed service access policies to the role to allow attaching workspaes to a directory
# https://docs.aws.amazon.com/workspaces/latest/adminguide/workspaces-access-control.html#create-default-role
# Provider docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_role_policy_attachment" "service_access" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonWorkSpacesServiceAccess"
}

resource "aws_iam_role_policy_attachment" "self_service_access" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonWorkSpacesSelfServiceAccess"
}

# ---------------------------------------------------------------------------------------------------------------------
# Connect workspaces to a managed directory
# Provider docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/workspaces_directory
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_workspaces_directory" "this" {
  directory_id = var.directory_id
  subnet_ids   = local.subnet_ids

  workspace_creation_properties {
    enable_internet_access   = var.enable_internet_access
    custom_security_group_id = local.custom_security_group_id
  }

  depends_on = [
    aws_iam_role_policy_attachment.service_access,
    aws_iam_role_policy_attachment.self_service_access
  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# Create a workspace per user
# Provider docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/workspaces_workspace
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_workspaces_workspace" "this" {
  for_each     = toset(var.usernames)
  directory_id = var.directory_id
  bundle_id    = var.bundle_id
  user_name    = each.value

  root_volume_encryption_enabled = var.root_volume_encryption_enabled
  user_volume_encryption_enabled = var.user_volume_encryption_enabled
  volume_encryption_key          = local.volume_encryption_key

  workspace_properties {
    compute_type_name                         = var.compute_type_name
    running_mode                              = var.running_mode
    user_volume_size_gib                      = var.user_volume_size_gib
    running_mode_auto_stop_timeout_in_minutes = var.running_mode_auto_stop_timeout_in_minutes
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Optionally create security group for workspace instances
# Provider docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "this" {
  count       = var.create_security_group == true ? 1 : 0
  name        = var.security_group_name
  description = var.security_group_description
  vpc_id      = var.vpc_id
}

# ---------------------------------------------------------------------------------------------------------------------
# Optionally create KMS Key for root volume and user volume encryption
# Provider docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_kms_key" "this" {
  count                    = var.create_kms_key == true ? 1 : 0
  description              = var.kms_key_description
  deletion_window_in_days  = var.kms_key_deletion_window_in_days
  key_usage                = var.kms_key_usage
  customer_master_key_spec = var.kms_key_customer_master_key_spec
}
