# Terraform module to provision Amazon Workspaces virtual desktops backed by AWS managed AD
Terraform 0.12+ module to provision Amazon Workspaces virtual desktops for specific users referenced by AWS managed AD

## Examples
### Minimal example
It is assumed a Managed AD directory has already been created, for example with [voquis/directory-service-with-logging](https://registry.terraform.io/modules/voquis/directory-service-with-logging/aws/latest) in addition to a VPC, for example with [voquis/vpc-subnets-internet](https://registry.terraform.io/modules/voquis/vpc-subnets-internet/aws/latest).

```terraform
module "workspaces" {
  source  = "voquis/workspaces-directory-service/aws"
  version = "0.0.1"

  directory_id = module.ad.directory_service_directory.id
  vpc_id       = module.vpc.vpc.id
  subnet_ids   = [
    module.vpc.subnets[1].id,
    module.vpc.subnets[2].id,
  ]

  usernames    = [
    "first.last1",
    "first.last2",
  ]
}

```
