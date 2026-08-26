output "cluster_id" {
  value       = google_alloydb_cluster.main.id
  description = "ID of the AlloyDB cluster"
}

output "cluster_name" {
  value       = google_alloydb_cluster.main.name
  description = "Name of the AlloyDB cluster"
}

output "instance_id" {
  value       = google_alloydb_instance.primary.id
  description = "ID of the AlloyDB primary instance"
}

output "instance_ip_address" {
  value       = google_alloydb_instance.primary.ip_address
  description = "Private IP address of the AlloyDB primary instance"
}

output "backup_id" {
  value       = google_alloydb_backup.nightly.id
  description = "ID of the on-demand AlloyDB backup"
}
