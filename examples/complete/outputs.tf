# Output VPC
output "vpc_id" {
  description = "The ID of the VPC."
  value       = module.k8s.vpc_id
}

output "vswitch_ids" {
  description = "List ID of the VSwitches."
  value       = module.k8s.vswitch_ids
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway."
  value       = module.k8s.nat_gateway_id
}

# Output kubernetes resource
output "cluster_id" {
  description = "ID of the kunernetes cluster."
  value       = module.k8s.cluster_id
}

output "security_group_id" {
  description = "ID of the Security Group used to deploy kubernetes cluster."
  value       = module.k8s.security_group_id
}

output "cluster_nodes" {
  description = "List nodes of cluster."
  value       = module.k8s.cluster_nodes
}

output "this_k8s_node_ids" {
  description = "List ids of of cluster node."
  value       = module.k8s.this_k8s_node_ids
}

output "output_file" {
  description = "The name of the output file."
  value       = data.alicloud_cs_cluster_credential.auth.output_file

}
