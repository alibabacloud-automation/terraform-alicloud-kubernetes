provider "alicloud" {
  region  = "cn-hangzhou"
}

module "k8s" {
  source = "../.."

  new_nat_gateway       = true
  k8s_pod_cidr          = "192.168.5.0/24"
  k8s_service_cidr      = "192.168.2.0/24"
  k8s_worker_number     = 2
  k8s_version           = "1.24.6-aliyun.1"
}