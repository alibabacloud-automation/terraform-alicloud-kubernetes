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
  source = "../.."
  region = var.region

  new_nat_gateway       = false
  vpc_id                = data.alicloud_vpcs.default.vpcs.0.id
  vswitch_ids           = ["vsw-bp1pog8voc3f42arr****", "vsw-bp1jxetj1386gqssg****", "vsw-bp1s1835sq5tjss9s****"]
  master_instance_types = ["ecs.n1.medium", "ecs.c5.large", "ecs.n1.medium"]
  worker_instance_types = ["ecs.n1.medium"]
  k8s_pod_cidr          = "192.168.5.0/24"
  k8s_service_cidr      = "192.168.2.0/24"
  k8s_worker_number     = 2
}