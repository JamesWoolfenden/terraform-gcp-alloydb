resource "google_alloydb_backup" "nightly" {
  backup_id    = "${var.cluster_id}-nightly"
  cluster_name = google_alloydb_cluster.main.name
  location     = var.location
  type         = "ON_DEMAND"

  encryption_config {
    kms_key_name = var.kms_key_name
  }

  depends_on = [google_alloydb_instance.primary]
}
