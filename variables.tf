
######################
# Instance typs variables
######################
variable "cpu_core_count" {
  description = "CPU core count is used to fetch instance types."
  type        = number
  default     = 1
}

variable "memory_size" {
  description = "Memory size used to fetch instance types."
  type        = number
  default     = 2
}

variable "k8s_number" {
  description = "The number of kubernetes cluster."
  type        = number
  default     = 1
}

######################
# VPC variables
######################
variable "vpc_name" {
  description = "The vpc name used to create a new vpc when 'vpc_id' is not specified. Default to variable `example_name`"
  type        = string
  default     = ""
}

variable "create_vpc" {
  description = "Boolean.  If you have a vpc already, use that one, else make this true and one will be created."
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "Existing vpc id used to create several vswitches and other resources."
  type        = string
  default     = ""
}

variable "example_name" {
  description = "The name as prefix used to create resources."
  type        = string
  default     = "tf-example-kubernetes"
}

variable "vpc_cidr" {
  description = "The cidr block used to launch a new vpc when 'vpc_id' is not specified."
  type        = string
  default     = "10.0.0.0/8"
}

######################
# VSwitch variables
######################
variable "vswitch_name_prefix" {
  type        = string
  description = "The vswitch name prefix used to create several new vswitches. Default to variable 'example_name'."
  default     = ""
}

variable "number_format" {
  description = "The number format used to output."
  type        = string
  default     = "%02d"
}

variable "vswitch_ids" {
  description = "List of existing vswitch id."
  type        = list(string)
  default     = []
}

variable "vswitch_cidrs" {
  description = "List of cidr blocks used to create several new vswitches when 'vswitch_ids' is not specified."
  type        = list(string)
  default     = ["10.1.0.0/16", "10.2.0.0/16", "10.3.0.0/16"]
}

variable "k8s_name_prefix" {
  description = "The name prefix used to create several kubernetes clusters. Default to variable `example_name`"
  type        = string
  default     = ""
}

variable "new_nat_gateway" {
  type        = bool
  description = "Whether to create a new nat gateway. In this template, a new nat gateway will create a nat gateway, eip and server snat entries."
  default     = true
}

variable "master_instance_types" {
  description = "The ecs instance types used to launch master nodes."
  type        = list(string)
  default     = []
}

variable "worker_instance_types" {
  description = "The ecs instance types used to launch worker nodes."
  type        = list(string)
  default     = []
}

variable "node_cidr_mask" {
  type        = number
  description = "The node cidr block to specific how many pods can run on single node. Valid values: [24-28]."
  default     = 24
}

variable "enable_ssh" {
  description = "Enable login to the node through SSH."
  type        = bool
  default     = false
}

variable "cpu_policy" {
  type        = string
  description = "kubelet cpu policy. Valid values: 'none','static'. Default to 'none'."
  default     = "none"
}

variable "proxy_mode" {
  description = "Proxy mode is option of kube-proxy. Valid values: 'ipvs','iptables'. Default to 'iptables'."
  type        = string
  default     = "iptables"
}

variable "master_password" {
  description = "The password of master ECS instance."
  type        = string
  default     = "Just4Test"
}

variable "k8s_worker_number" {
  description = "The number of worker nodes in kubernetes cluster."
  type        = number
  default     = 2
}

# k8s_pod_cidr is only for flannel network
variable "k8s_pod_cidr" {
  description = "The kubernetes pod cidr block. It cannot be equals to vpc's or vswitch's and cannot be in them."
  type        = string
  default     = "172.20.0.0/16"
}

variable "k8s_service_cidr" {
  description = "The kubernetes service cidr block. It cannot be equals to vpc's or vswitch's or pod's and cannot be in them."
  type        = string
  default     = "172.21.0.0/20"
}

variable "k8s_version" {
  description = "The version of the kubernetes version."
  type        = string
  default     = ""
}

variable "cluster_addons" {
  description = "Addon components in kubernetes cluster"
  type = list(object({
    name   = string
    config = string
  }))
  default = []
}

######################
# node pool variables
######################

variable "worker_password" {
  description = "The password of worker ECS instance."
  type        = list(string)
  default     = ["Just4Test"]
}

variable "install_cloud_monitor" {
  description = "Install cloud monitor agent on ECS."
  type        = bool
  default     = true
}

variable "instance_charge_type" {
  description = "The charge type of instance. Choices are 'PostPaid' and 'PrePaid'."
  type        = string
  default     = "PostPaid"
}

variable "subscription" {
  description = "A mapping of fields for Prepaid ECS instances created. "
  type        = map(string)
  default = {
    period            = 1
    period_unit       = "Month"
    auto_renew        = false
    auto_renew_period = 1
  }
}

variable "system_disk_category" {
  description = "The system disk category used to launch one or more worker ecs instances."
  type        = string
  default     = "cloud_efficiency"
}

variable "system_disk_size" {
  description = "The system disk size used to launch one or more worker ecs instances."
  type        = number
  default     = 40
}

variable "data_disks" {
  description = "Additional data disks to attach to the scaled ECS instance."
  type        = list(map(string))
  default     = []
}

