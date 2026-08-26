resource "google_alloydb_instance" "primary" {
  cluster       = google_alloydb_cluster.main.name
  instance_id   = var.instance_id
  instance_type = "PRIMARY"

  machine_config {
    cpu_count = var.cpu_count
  }

  network_config {
    enable_public_ip = false
  }

  database_flags = merge({
    "alloydb.enable_pgaudit"      = "on"
    "pgaudit.log"                 = "ddl,role,write"
    "password.enforce_complexity" = "on"
  }, var.database_flags)
}
