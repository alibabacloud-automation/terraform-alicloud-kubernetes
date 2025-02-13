# Output VPC
output "vpc_id" {
  description = "The ID of the VPC."
  value       = alicloud_cs_kubernetes.k8s[0].vpc_id
}

output "vswitch_ids" {
  description = "List ID of the VSwitches."
  value       = [alicloud_cs_kubernetes.k8s[*].vswitch_ids]
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway."
  value       = alicloud_cs_kubernetes.k8s[0].nat_gateway_id
}

# Output kubernetes resource
output "cluster_id" {
  description = "ID of the kunernetes cluster."
  value       = alicloud_cs_kubernetes.k8s[*].id
}

output "security_group_id" {
  description = "ID of the Security Group used to deploy kubernetes cluster."
  value       = alicloud_cs_kubernetes.k8s[0].security_group_id
}

output "cluster_nodes" {
  description = "List nodes of cluster."
  value       = alicloud_cs_kubernetes.k8s[*].worker_nodes
}

output "this_k8s_node_ids" {
  description = "List ids of of cluster node."
  value       = [for _, obj in concat(alicloud_cs_kubernetes.k8s[*].worker_nodes, [{}])[0] : obj["id"]]
}
