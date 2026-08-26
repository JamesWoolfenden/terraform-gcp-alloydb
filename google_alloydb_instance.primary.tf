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

  database_flags = {
    "alloydb.enable_pgaudit"      = "on"
    "password.enforce_complexity" = "on"
  }
}
