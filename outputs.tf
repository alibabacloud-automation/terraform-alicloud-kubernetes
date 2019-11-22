// Output VPC
output "this_vpc_id" {
  description = "The ID of the VPC."
  value       = alicloud_cs_kubernetes.k8s.vpc_id
}

output "this_vswitch_ids" {
  description = "List ID of the VSwitches."
  value       = alicloud_cs_kubernetes.k8s.vswitch_ids
}

output "this_nat_gateway_id" {
  value = alicloud_cs_kubernetes.k8s.nat_gateway_id
}

// Output kubernetes resource
output "this_cluster_id" {
  description = "ID of the kunernetes cluster."
  value       = alicloud_cs_kubernetes.k8s.id
}

output "this_security_group_id" {
  description = "ID of the Security Group used to deploy kubernetes cluster."
  value       = alicloud_cs_kubernetes.k8s.security_group_id
}

output "this_cluster_nodes" {
  description = "List nodes of cluster."
  value       = alicloud_cs_kubernetes.k8s.worker_nodes
}

