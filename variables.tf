# common variables


variable "region" {
  description = "The region used to launch this module resources."
  default     = ""
}

variable "profile" {
  description = "The profile name as set in the shared credentials file. If not set, it will be sourced from the ALICLOUD_PROFILE environment variable."
  default     = ""
}
variable "shared_credentials_file" {
  description = "This is the path to the shared credentials file. If this is not set and a profile is specified, $HOME/.aliyun/config.json will be used."
  default     = ""
}

variable "skip_region_validation" {
  description = "Skip static validation of region ID. Used by users of alternative AlibabaCloud-like APIs or users w/ access to regions that are not public (yet)."
  default     = false
}

variable "filter_with_name_regex" {
  description = "A default filter applied to retrieve existing vswitches, nat gateway, eip, snat entry and kubernetes clusters by name regex."
  default     = ""
}

variable "filter_with_tags" {
  description = "A default filter applied to retrieve existing vswitches, nat gateway, eip, snat entry and kubernetes clusters by tags."
  type        = map(string)
  default     = {}
}

variable "filter_with_resource_group_id" {
  description = "A default filter applied to retrieve existing vswitches, nat gateway, eip, snat entry and kubernetes clusters by resource group id."
  default     = ""
}

# Instancetypes variables
variable "cpu_core_count" {
  description = "CPU core count is used to fetch instancetypes."
  default     = 2
}

variable "memory_size" {
  description = "Memory size used to fetch instancetypes."
  default     = 4
}

# VSwitch variables

variable "vswitch_name_regex" {
  description = "A default filter applied to retrieve existing vswitches by name regex. If not set, `filter_with_name_regex` will be used."
  default     = ""
}

variable "vswitch_tags" {
  description = "A default filter applied to retrieve existing vswitches by tags. If not set, `filter_with_tags` will be used."
  type        = map(string)
  default     = {}
}

variable "vswitch_resource_group_id" {
  description = "A default filter applied to retrieve existing vswitches by resource group id. If not set, `filter_with_resource_group_id` will be used."
  default     = ""
}

variable "vswitch_ids" {
  description = "List of existing vswitch id."
  type        = list(string)
  default     = []
}

variable "new_nat_gateway" {
  description = "Whether to create a new nat gateway. In this template, a new nat gateway will create a nat gateway, eip and server snat entries."
  default     = "true"
}

# Cluster nodes variables

variable "master_instance_types" {
  description = "The ecs instance type used to launch master nodes. Default from instance types datasource."
  type        = list(string)
  default     = []
}

variable "worker_instance_types" {
  description = "The ecs instance type used to launch worker nodes. Default from instance types datasource."
  type        = list(string)
  default     = []
}

variable "master_disk_category" {
  description = "The system disk category used to launch one or more master nodes."
  default     = "cloud_efficiency"
}

variable "worker_disk_category" {
  description = "The system disk category used to launch one or more worker nodes."
  default     = "cloud_efficiency"
}

variable "master_disk_size" {
  description = "The system disk size used to launch one or more master nodes."
  default     = "40"
}

variable "worker_disk_size" {
  description = "The system disk size used to launch one or more worker nodes."
  default     = "40"
}

variable "ecs_password" {
  description = "The password of instance."
  default     = "Abc12345"
}

variable "k8s_worker_numbers" {
  description = "The number of worker nodes in each kubernetes cluster."
  type        = list(number)
  default     = [3]
}

variable "k8s_name" {
  description = "The name used to create kubernetes cluster."
  default     = "tf-example-kubernetes"
}

variable "k8s_pod_cidr" {
  description = "The kubernetes pod cidr block. It cannot be equals to vpc's or vswitch's and cannot be in them."
  default     = "172.20.0.0/16"
}

variable "k8s_service_cidr" {
  description = "The kubernetes service cidr block. It cannot be equals to vpc's or vswitch's or pod's and cannot be in them."
  default     = "172.21.0.0/20"
}

