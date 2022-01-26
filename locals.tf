locals {
  subnet_ids = [
    var.subnet_ids[0],
    var.subnet_ids[1],
  ]
  custom_security_group_id = var.create_security_group == false ? var.security_group_id : aws_security_group.this[0].id
  volume_encryption_key    = var.create_kms_key == false ? var.kms_key_arn : aws_kms_key.this[0].id
}
