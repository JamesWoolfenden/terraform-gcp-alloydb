resource "google_alloydb_cluster" "main" {
  cluster_id          = var.cluster_id
  location            = var.location
  deletion_protection = var.deletion_protection

  network_config {
    network = var.network
  }

  encryption_config {
    kms_key_name = var.kms_key_name
  }

  continuous_backup_config {
    enabled              = true
    recovery_window_days = var.recovery_window_days

    encryption_config {
      kms_key_name = var.kms_key_name
    }
  }

  automated_backup_policy {
    location      = var.location
    backup_window = "1800s"
    enabled       = true

    weekly_schedule {
      days_of_week = ["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"]

      start_times {
        hours   = 2
        minutes = 0
        seconds = 0
        nanos   = 0
      }
    }

    quantity_based_retention {
      count = var.backup_retention_count
    }

    encryption_config {
      kms_key_name = var.kms_key_name
    }
  }

  lifecycle {
    ignore_changes = [
      restore_continuous_backup_source,
      restore_backup_source,
    ]
  }
}
