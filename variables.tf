# Required parameters
variable "directory_id" {
  type        = string
  description = "AWS Managed AD directory ID from which users will be searched"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to create workspaces in"
}

variable "subnet_ids" {
  type        = list(string)
  description = "VPC Subnet IDs to create workspaces in"
}

variable "usernames" {
  type        = list(string)
  description = "(optional) describe your variable"
}

# Optional parameters

# Use the following AWS CLI command to get all available bundles:
#aws workspaces describe-workspace-bundles --owner AMAZON
# wsb-9jvhtb24f Windows 10 Experience provided by Windows Server 2016 with Office 2016 and PCoIP 2 vCPU 4GiB Memory 50GB Storage
variable "bundle_id" {
  type        = string
  description = "(optional) The workspace bundle to use"
  default     = "wsb-9jvhtb24f"
}

# Workspaces directory settings
variable "enable_internet_access" {
  type        = bool
  description = "(optional) Whether workspace virtual desktops should have internet access. Note that a VPC internet gateway is not required."
  default     = true
}

# Security group settings
variable "create_security_group" {
  type        = bool
  description = "(optional) Whether a security group should be created for the workspaces. If true, a new security group will be created and available as an outputs to attach rules."
  default     = true
}

variable "security_group_name" {
  type        = string
  description = "(optional) Security group name if this module is creating the resource"
  default     = "workspaces"
}

variable "security_group_description" {
  type        = string
  description = "(optional) Security group description if this module is creating the resource"
  default     = "workspaces"
}

variable "security_group_id" {
  type        = string
  description = "(optional) If a security group should not be created, the security group id to use. Requires that `create_security_group` be set to `false`"
  default     = null
}

# Workspace settings
variable "root_volume_encryption_enabled" {
  type        = bool
  description = "(optional) Whether root volume encryption is enabled"
  default     = true
}

variable "user_volume_encryption_enabled" {
  type        = bool
  description = "(optional) Whether user volume encryption is enabled"
  default     = true
}

variable "compute_type_name" {
  type        = string
  description = "(optional) Workspace compute type name"
  default     = "STANDARD"
}

variable "running_mode" {
  type        = string
  description = "(optional) Workspace running mode"
  default     = "AUTO_STOP"
}

variable "running_mode_auto_stop_timeout_in_minutes" {
  type        = number
  description = "(optional) The time after a user logs off when WorkSpaces are automatically stopped. Configured in 60-minute intervals"
  default     = 60
}

variable "user_volume_size_gib" {
  type        = number
  description = "(optional) User volume size in GB"
  default     = 10
}

# KMS key settings
variable "create_kms_key" {
  type        = bool
  description = "(optional) Whether a KMS key for workspace user volume and root volume encryption should be created."
  default     = true
}

variable "kms_key_arn" {
  type        = string
  description = "(optional) If a KMS key for encyrption of workspace volumes should not be created, the KMS key arn to use. Requires that `create_kms_key` be set to `false`"
  default     = null
}

variable "kms_key_description" {
  type        = string
  description = "(optional) KMS key description if this module is creating the resource"
  default     = "workspaces"
}

variable "kms_key_deletion_window_in_days" {
  type        = number
  description = "(optional) KMS key deletion window in days if this module is creating the resource"
  default     = 10
}

variable "kms_key_usage" {
  type        = string
  description = "(optional) KMS key usage if this module is creating the resource"
  default     = "ENCRYPT_DECRYPT"
}

variable "kms_key_customer_master_key_spec" {
  type        = string
  description = "(optional) KMS key customer master key spec if this module is creating the resource"
  default     = "SYMMETRIC_DEFAULT"
}
