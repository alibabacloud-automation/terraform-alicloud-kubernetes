Alibaba Cloud terraform example for kubernetes cluster
======================================================

A terraform example to launching a kubernetes cluster in alibaba cloud.

These types of the module resource are supported:

- [VPC](https://www.terraform.io/docs/providers/alicloud/r/vpc.html)
- [Subnet](https://www.terraform.io/docs/providers/alicloud/r/vswitch.html)
- [ECS Instance](https://www.terraform.io/docs/providers/alicloud/r/instance.html)
- [Security Group](https://www.terraform.io/docs/providers/alicloud/r/security_group.html)
- [Nat Gateway](https://www.terraform.io/docs/providers/alicloud/r/nat_gateway.html)
- [Kubernetes](https://www.terraform.io/docs/providers/alicloud/r/cs_kubernetes.html)

Usage
-----
This example can specify the following arguments to create user-defined kuberntes cluster

* alicloud_access_key: The Alicloud Access Key ID
* alicloud_secret_key: The Alicloud Access Secret Key
* region: The ID of region in which launching resources
* k8s_name_prefix: The name prefix of kubernetes cluster
* k8s_number: The number of kubernetes cluster
* k8s_worker_number: The number of worker nodes in each kubernetes cluster
* k8s_pod_cidr: The kubernetes pod cidr block. It cannot be equals to vpc's or vswitch's and cannot be in them. If vpc's cidr block is `172.16.XX.XX/XX`,
it had better to `192.168.XX.XX/XX` or `10.XX.XX.XX/XX`
* k8s_service_cidr: The kubernetes service cidr block. Its setting rule is same as `k8s_pod_cidr`
* Other kubernetes cluster arguments

**Note:** In order to avoid some needless error, you had better to set `new_nat_gateway` to `true`.
Otherwise, you must you must ensure you specified vswitches can access internet before running the example.

Planning phase

    terraform plan

Apply phase

	terraform apply


Destroy

    terraform destroy


Conditional creation
--------------------
This example can support the following creating kubernetes cluster scenario by setting different arguments.

### 1. Create a new vpc, vswitches and nat gateway for the cluster.

You can specify the following user-defined arguments:

* vpc_name: A new vpc name
* vpc_cidr: A new vpc cidr block
* vswitch_name_prefix: The name prefix of several vswitches
* vswitch_cidrs: List of cidr blocks for several new vswitches

```hcl
variable "profile" {
  default = "default"
}

variable "region" {
  default = "cn-hangzhou"
}

data "alicloud_vpcs" "default" {
  is_default = true
}

module "k8s" {
  source = "../"

  new_nat_gateway       = true
  vpc_name              = "tf-k8s-vpc"
  vpc_cidr              = "10.0.0.0/8"
  vswitch_name_prefix   = "tf-k8s-vsw"
  vswitch_cidrs         = ["10.1.0.0/16", "10.2.0.0/16", "10.3.0.0/16"]
  master_instance_types = ["ecs.n1.medium", "ecs.c5.large", "ecs.n1.medium"]
  worker_instance_types = ["ecs.n1.medium"]
  k8s_pod_cidr          = "192.168.5.0/24"
  k8s_service_cidr      = "192.168.2.0/24"
  k8s_worker_number     = 2
}
```

### 2. Using existing vpc and vswitches for the cluster.

You can specify the following user-defined arguments:

* vpc_id: A existing vpc ID
* vswitch_ids: List of IDs for several existing vswitches

```hcl
variable "profile" {
  default = "default"
}

variable "region" {
  default = "cn-hangzhou"
}

data "alicloud_vpcs" "default" {
  is_default = true
}

module "k8s" {
  source = "../"

  vpc_id                = data.alicloud_vpcs.default.vpcs.0.id
  vswitch_ids           = ["vsw-bp1pog8voc3f42arr****", "vsw-bp1jxetj1386gqssg****", "vsw-bp1s1835sq5tjss9s****"]
  master_instance_types = ["ecs.n1.medium", "ecs.c5.large", "ecs.n1.medium"]
  worker_instance_types = ["ecs.n1.medium"]
  k8s_pod_cidr          = "192.168.5.0/24"
  k8s_service_cidr      = "192.168.2.0/24"
  k8s_worker_number     = 2
}
```

### 3. Using existing vpc, vswitches and nat gateway for the cluster.

You can specify the following user-defined arguments:

* vpc_id: A existing vpc ID
* vswitch_ids: List of IDs for several existing vswitches
* new_nat_gateway: Set it to false. But you must ensure you specified vswitches can access internet.
In other words, you must set snat entry for each vswitch before running the example.

```hcl
variable "profile" {
  default = "default"
}

variable "region" {
  default = "cn-hangzhou"
}

data "alicloud_vpcs" "default" {
  is_default = true
}

module "k8s" {
  source = "../"

  new_nat_gateway       = false
  vpc_id                = data.alicloud_vpcs.default.vpcs.0.id
  vswitch_ids           = ["vsw-bp1pog8voc3f42arr****", "vsw-bp1jxetj1386gqssg****", "vsw-bp1s1835sq5tjss9s****"]
  master_instance_types = ["ecs.n1.medium", "ecs.c5.large", "ecs.n1.medium"]
  worker_instance_types = ["ecs.n1.medium"]
  k8s_pod_cidr          = "192.168.5.0/24"
  k8s_service_cidr      = "192.168.2.0/24"
  k8s_worker_number     = 2
}
```

## Examples

* [complete example](https://github.com/terraform-alicloud-modules/terraform-alicloud-kubernetes/tree/master/examples/complete)

## Notes
From the version v1.4.0, the module has removed the following `provider` setting:

```hcl
provider "alicloud" {
  profile                 = var.profile != "" ? var.profile : null
  shared_credentials_file = var.shared_credentials_file != "" ? var.shared_credentials_file : null
  region                  = var.region
  skip_region_validation  = var.skip_region_validation
  configuration_source    = "terraform-alicloud-modules/kubernetes"
}
```

If you still want to use the `provider` setting to apply this module, you can specify a supported version, like 1.3.0:

```hcl
module "k8s" {
  source          = "terraform-alicloud-modules/kubernetes/alicloud"
  version         = "1.3.0"
  region          = "cn-hangzhou"
  profile         = "Your-Profile-Name"
  new_nat_gateway = true
  vpc_name        = "tf-k8s-vpc"
  // ...
}
```

If you want to upgrade the module to 1.4.0 or higher in-place, you can define a provider which same region with
previous region:

```hcl
provider "alicloud" {
  region  = "cn-hangzhou"
  profile = "Your-Profile-Name"
}
module "k8s" {
  source          = "terraform-alicloud-modules/kubernetes/alicloud"
  new_nat_gateway = true
  vpc_name        = "tf-k8s-vpc"
  // ...
}
```
or specify an alias provider with a defined region to the module using `providers`:

```hcl
provider "alicloud" {
  region  = "cn-hangzhou"
  profile = "Your-Profile-Name"
  alias   = "hz"
}
module "k8s" {
  source          = "terraform-alicloud-modules/kubernetes/alicloud"
  providers  = {
    alicloud = alicloud.hz
  }
  new_nat_gateway = true
  vpc_name        = "tf-k8s-vpc"
  // ...
}
```

and then run `terraform init` and `terraform apply` to make the defined provider effect to the existing module state.

More details see [How to use provider in the module](https://www.terraform.io/docs/language/modules/develop/providers.html#passing-providers-explicitly)

## Terraform versions

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.0 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | >= 1.75.0 |

Submit Issues
-------------
If you have any problems when using this module, please opening a [provider issue](https://github.com/terraform-providers/terraform-provider-alicloud/issues/new) and let us know.

**Note:** There does not recommend to open an issue on this repo.

Authors
-------
Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com)

License
-------
Mozilla Public License 2.0. See LICENSE for full details.

Reference
---------
* [Terraform-Provider-Alicloud Github](https://github.com/terraform-providers/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://www.terraform.io/docs/providers/alicloud/)


