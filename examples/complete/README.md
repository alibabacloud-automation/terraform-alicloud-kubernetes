Terraform module for creating Kubernetes Cluster on Alibaba Cloud.  
terraform-alicloud-kubernetes
=====================================================================

## Note

1. specifications in `master_instance_types` and `worker_instance_types` parameter
   1. can't be sharable instance type (共享型实例).
   2. if specify some instance type, check if it supports the `disk_category` parameter, which is `cloud_ssd`(SSD云盘) by default. Or you should set the `disk_catagory` parameter.
2. to specify region where VPC is created, use provider.

```hcl
# default provider configuration
provider "alicloud" {
  public_key  = "your_public_key"
  private_key = "your_private_key"
  project_id  = "your_project_id"
  region      = "cn-beijing"
}

# new configuration
provider "alicloud" {
  alias  = "hz" # alias
  region = "cn-hangzhou"
}

resource "alicloud_vpc" "default" {
  provider   = "alicloud.hz"
  cidr_block = "172.16.0.0/12"
  name       = var.name
}
```

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources which cost money. Run `terraform destroy` when you don't need these
resources.

