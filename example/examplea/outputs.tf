output "cluster_id" {
  value       = module.alloydb.cluster_id
  description = "ID of the AlloyDB cluster"
}

output "instance_ip_address" {
  value       = module.alloydb.instance_ip_address
  description = "Private IP address of the AlloyDB primary instance"
}
