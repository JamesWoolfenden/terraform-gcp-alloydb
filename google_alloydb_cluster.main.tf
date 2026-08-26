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
    backup_window = var.backup_window
    enabled       = true

    weekly_schedule {
      days_of_week = var.backup_days_of_week

      start_times {
        hours   = var.backup_start_hour
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

  maintenance_update_policy {
    maintenance_windows {
      day = var.maintenance_day

      start_time {
        hours   = var.maintenance_hour
        minutes = 0
        seconds = 0
        nanos   = 0
      }
    }
  }

  lifecycle {
    ignore_changes = [
      restore_continuous_backup_source,
      restore_backup_source,
    ]
  }
}
