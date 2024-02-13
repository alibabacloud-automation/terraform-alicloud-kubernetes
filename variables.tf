######################
# provider
######################
variable "region" {
  description = "(Deprecated from version 1.4.0) The region used to launch this module resources."
  type        = string
  default     = ""
}
variable "profile" {
  description = "(Deprecated from version 1.4.0) The profile name as set in the shared credentials file. If not set, it will be sourced from the ALICLOUD_PROFILE environment variable."
  type        = string
  default     = ""
}
variable "shared_credentials_file" {
  description = "(Deprecated from version 1.4.0) This is the path to the shared credentials file. If this is not set and a profile is specified, $HOME/.aliyun/config.json will be used."
  type        = string
  default     = ""
}
variable "skip_region_validation" {
  description = "(Deprecated from version 1.4.0) Skip static validation of region ID. Used by users of alternative AlibabaCloud-like APIs or users w/ access to regions that are not public (yet)."
  type        = bool
  default     = false
}

######################
# Zone
######################

variable "zone_id" {
  description = "The Zone to launch the instance."
  type        = string
  default     = ""
}

######################
# Instance typs variables
######################
variable "cpu_core_count" {
  description = "CPU core count is used to fetch instance types."
  type        = number
  default     = 4
}

variable "memory_size" {
  description = "Memory size used to fetch instance types."
  type        = number
  default     = 8
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

variable "disk_category" {
  description = "The disk category used to launch master and worker nodes. default 'cloud_ssd'"
  type        = string
  default     = "cloud_ssd"
}

variable "node_cidr_mask" {
  type        = number
  description = "The node cidr block to specific how many pods can run on single node. Valid values: [24-28]."
  default     = 24
}

variable "enable_ssh" {
  description = "Enable login to the node through SSH."
  type        = bool
  default     = true
}

variable "install_cloud_monitor" {
  description = "Install cloud monitor agent on ECS."
  type        = bool
  default     = true
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

variable "password" {
  description = "The password of ECS instance."
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
  description = "The version of the kubernetes version.  Valid values: '1.24.6-aliyun.1','1.22.15-aliyun.1'. Default to '1.24.6-aliyun.1'."
  type        = string
  default     = "1.24.6-aliyun.1"
}

variable "cluster_addons" {
  description = "Addon components in kubernetes cluster"
  type        = list(object({
    name   = string
    config = string
  }))
  default = []
}
