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

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [alicloud_cs_kubernetes.k8s](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cs_kubernetes) | resource |
| [alicloud_cs_kubernetes_node_pool.default](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cs_kubernetes_node_pool) | resource |
| [alicloud_eip.default](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/eip) | resource |
| [alicloud_eip_association.default](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/eip_association) | resource |
| [alicloud_nat_gateway.default](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/nat_gateway) | resource |
| [alicloud_snat_entry.default](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/snat_entry) | resource |
| [alicloud_vpc.vpc](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/vpc) | resource |
| [alicloud_vswitch.vswitches](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/vswitch) | resource |
| [alicloud_instance_types.default](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/data-sources/instance_types) | data source |
| [alicloud_zones.default](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/data-sources/zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_addons"></a> [cluster\_addons](#input\_cluster\_addons) | Addon components in kubernetes cluster | <pre>list(object({<br>    name   = string<br>    config = string<br>  }))</pre> | `[]` | no |
| <a name="input_cpu_core_count"></a> [cpu\_core\_count](#input\_cpu\_core\_count) | CPU core count is used to fetch instance types. | `number` | `1` | no |
| <a name="input_cpu_policy"></a> [cpu\_policy](#input\_cpu\_policy) | kubelet cpu policy. Valid values: 'none','static'. Default to 'none'. | `string` | `"none"` | no |
| <a name="input_create_vpc"></a> [create\_vpc](#input\_create\_vpc) | Boolean.  If you have a vpc already, use that one, else make this true and one will be created. | `bool` | `false` | no |
| <a name="input_data_disks"></a> [data\_disks](#input\_data\_disks) | Additional data disks to attach to the scaled ECS instance. | `list(map(string))` | `[]` | no |
| <a name="input_enable_ssh"></a> [enable\_ssh](#input\_enable\_ssh) | Enable login to the node through SSH. | `bool` | `false` | no |
| <a name="input_example_name"></a> [example\_name](#input\_example\_name) | The name as prefix used to create resources. | `string` | `"tf-example-kubernetes"` | no |
| <a name="input_install_cloud_monitor"></a> [install\_cloud\_monitor](#input\_install\_cloud\_monitor) | Install cloud monitor agent on ECS. | `bool` | `true` | no |
| <a name="input_instance_charge_type"></a> [instance\_charge\_type](#input\_instance\_charge\_type) | The charge type of instance. Choices are 'PostPaid' and 'PrePaid'. | `string` | `"PostPaid"` | no |
| <a name="input_k8s_name_prefix"></a> [k8s\_name\_prefix](#input\_k8s\_name\_prefix) | The name prefix used to create several kubernetes clusters. Default to variable `example_name` | `string` | `""` | no |
| <a name="input_k8s_number"></a> [k8s\_number](#input\_k8s\_number) | The number of kubernetes cluster. | `number` | `1` | no |
| <a name="input_k8s_pod_cidr"></a> [k8s\_pod\_cidr](#input\_k8s\_pod\_cidr) | The kubernetes pod cidr block. It cannot be equals to vpc's or vswitch's and cannot be in them. | `string` | `"172.20.0.0/16"` | no |
| <a name="input_k8s_service_cidr"></a> [k8s\_service\_cidr](#input\_k8s\_service\_cidr) | The kubernetes service cidr block. It cannot be equals to vpc's or vswitch's or pod's and cannot be in them. | `string` | `"172.21.0.0/20"` | no |
| <a name="input_k8s_version"></a> [k8s\_version](#input\_k8s\_version) | The version of the kubernetes version. | `string` | `""` | no |
| <a name="input_k8s_worker_number"></a> [k8s\_worker\_number](#input\_k8s\_worker\_number) | The number of worker nodes in kubernetes cluster. | `number` | `2` | no |
| <a name="input_master_instance_types"></a> [master\_instance\_types](#input\_master\_instance\_types) | The ecs instance types used to launch master nodes. | `list(string)` | `[]` | no |
| <a name="input_master_password"></a> [master\_password](#input\_master\_password) | The password of master ECS instance. | `string` | `"Just4Test"` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Memory size used to fetch instance types. | `number` | `2` | no |
| <a name="input_new_nat_gateway"></a> [new\_nat\_gateway](#input\_new\_nat\_gateway) | Whether to create a new nat gateway. In this template, a new nat gateway will create a nat gateway, eip and server snat entries. | `bool` | `true` | no |
| <a name="input_node_cidr_mask"></a> [node\_cidr\_mask](#input\_node\_cidr\_mask) | The node cidr block to specific how many pods can run on single node. Valid values: [24-28]. | `number` | `24` | no |
| <a name="input_number_format"></a> [number\_format](#input\_number\_format) | The number format used to output. | `string` | `"%02d"` | no |
| <a name="input_proxy_mode"></a> [proxy\_mode](#input\_proxy\_mode) | Proxy mode is option of kube-proxy. Valid values: 'ipvs','iptables'. Default to 'iptables'. | `string` | `"iptables"` | no |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | A mapping of fields for Prepaid ECS instances created. | `map(string)` | <pre>{<br>  "auto_renew": false,<br>  "auto_renew_period": 1,<br>  "period": 1,<br>  "period_unit": "Month"<br>}</pre> | no |
| <a name="input_system_disk_category"></a> [system\_disk\_category](#input\_system\_disk\_category) | The system disk category used to launch one or more worker ecs instances. | `string` | `"cloud_efficiency"` | no |
| <a name="input_system_disk_size"></a> [system\_disk\_size](#input\_system\_disk\_size) | The system disk size used to launch one or more worker ecs instances. | `number` | `40` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | The cidr block used to launch a new vpc when 'vpc\_id' is not specified. | `string` | `"10.0.0.0/8"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Existing vpc id used to create several vswitches and other resources. | `string` | `""` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | The vpc name used to create a new vpc when 'vpc\_id' is not specified. Default to variable `example_name` | `string` | `""` | no |
| <a name="input_vswitch_cidrs"></a> [vswitch\_cidrs](#input\_vswitch\_cidrs) | List of cidr blocks used to create several new vswitches when 'vswitch\_ids' is not specified. | `list(string)` | <pre>[<br>  "10.1.0.0/16",<br>  "10.2.0.0/16",<br>  "10.3.0.0/16"<br>]</pre> | no |
| <a name="input_vswitch_ids"></a> [vswitch\_ids](#input\_vswitch\_ids) | List of existing vswitch id. | `list(string)` | `[]` | no |
| <a name="input_vswitch_name_prefix"></a> [vswitch\_name\_prefix](#input\_vswitch\_name\_prefix) | The vswitch name prefix used to create several new vswitches. Default to variable 'example\_name'. | `string` | `""` | no |
| <a name="input_worker_instance_types"></a> [worker\_instance\_types](#input\_worker\_instance\_types) | The ecs instance types used to launch worker nodes. | `list(string)` | `[]` | no |
| <a name="input_worker_password"></a> [worker\_password](#input\_worker\_password) | The password of worker ECS instance. | `list(string)` | <pre>[<br>  "Just4Test"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | ID of the kunernetes cluster. |
| <a name="output_cluster_nodes"></a> [cluster\_nodes](#output\_cluster\_nodes) | List nodes of cluster. |
| <a name="output_nat_gateway_id"></a> [nat\_gateway\_id](#output\_nat\_gateway\_id) | The ID of the NAT Gateway. |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | ID of the Security Group used to deploy kubernetes cluster. |
| <a name="output_this_k8s_node_ids"></a> [this\_k8s\_node\_ids](#output\_this\_k8s\_node\_ids) | List ids of of cluster node. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC. |
| <a name="output_vswitch_ids"></a> [vswitch\_ids](#output\_vswitch\_ids) | List ID of the VSwitches. |
<!-- END_TF_DOCS -->

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


