
provider "alicloud" {
  region = "cn-hangzhou"
}

data "alicloud_zones" "default" {
  available_resource_creation = "VSwitch"
}

resource "alicloud_vpc" "default" {
  vpc_name   = "tf_module"
  cidr_block = "10.4.0.0/16"
}

resource "alicloud_vswitch" "default" {
  count      = 3
  vpc_id     = alicloud_vpc.default.id
  cidr_block = cidrsubnet(alicloud_vpc.default.cidr_block, 8, count.index)
  zone_id    = data.alicloud_zones.default.zones[0].id
}

data "alicloud_instance_types" "cloud_essd" {
  availability_zone    = data.alicloud_zones.default.zones[0].id
  cpu_core_count       = 4
  memory_size          = 8
  system_disk_category = "cloud_essd"
}

module "k8s" {
  source = "../.."

  new_nat_gateway       = false
  vpc_id                = alicloud_vpc.default.id
  vswitch_ids           = alicloud_vswitch.default[*].id
  master_instance_types = [data.alicloud_instance_types.cloud_essd.instance_types[0].id, data.alicloud_instance_types.cloud_essd.instance_types[1].id, data.alicloud_instance_types.cloud_essd.instance_types[2].id]
  worker_instance_types = [data.alicloud_instance_types.cloud_essd.instance_types[0].id]
  k8s_pod_cidr          = "10.72.0.0/16"
  k8s_service_cidr      = "172.18.0.0/16"
  k8s_worker_number     = 2

  data_disks = [{
    category = "cloud_efficiency"
    size     = 40
  }]
}

data "alicloud_cs_cluster_credential" "auth" {
  cluster_id                 = module.k8s.cluster_id[0]
  temporary_duration_minutes = 60
  output_file                = "~/.kube/config"
}