variable "cluster_id" {
  type        = string
  description = "Identifier of the AlloyDB cluster"

  validation {
    condition     = length(trimspace(var.cluster_id)) > 0
    error_message = "var.cluster_id must be a non-empty string"
  }
}

variable "instance_id" {
  type        = string
  description = "Identifier of the AlloyDB primary instance"

  validation {
    condition     = length(trimspace(var.instance_id)) > 0
    error_message = "var.instance_id must be a non-empty string"
  }
}

variable "location" {
  type        = string
  description = "Region of the AlloyDB cluster"
  default     = "europe-west2"

  validation {
    condition     = length(trimspace(var.location)) > 0
    error_message = "var.location must be a non-empty string"
  }
}

variable "network" {
  type        = string
  description = "Self-link of the VPC network the cluster attaches to, e.g. `projects/<project-number>/global/networks/<name>`"

  validation {
    condition     = can(regex("^projects/[^/]+/global/networks/[^/]+$", var.network))
    error_message = "var.network must be of the form projects/<project>/global/networks/<name>"
  }
}

variable "kms_key_name" {
  type        = string
  description = "Resource name of the Cloud KMS key used to encrypt the cluster, its backups and its continuous backups (CMEK)"

  validation {
    condition     = length(trimspace(var.kms_key_name)) > 0
    error_message = "var.kms_key_name must be a non-empty string"
  }
}

variable "cpu_count" {
  type        = number
  description = "vCPU count of the primary instance"
  default     = 2

  validation {
    condition     = contains([2, 4, 8, 16, 32, 64, 96, 128], var.cpu_count)
    error_message = "var.cpu_count must be one of 2, 4, 8, 16, 32, 64, 96 or 128"
  }
}

variable "recovery_window_days" {
  type        = number
  description = "Continuous backup recovery window, in days"
  default     = 14

  validation {
    condition     = var.recovery_window_days >= 1 && var.recovery_window_days <= 35
    error_message = "var.recovery_window_days must be between 1 and 35"
  }
}

variable "backup_retention_count" {
  type        = number
  description = "Number of automated backups to retain"
  default     = 14

  validation {
    condition     = var.backup_retention_count >= 1
    error_message = "var.backup_retention_count must be at least 1"
  }
}

variable "deletion_protection" {
  type        = bool
  description = "Whether the cluster is protected from deletion"
  default     = true
}

variable "database_flags" {
  type        = map(string)
  description = "Additional PostgreSQL database flags, merged over the module's baseline (pgaudit and password complexity). Keys given here win, except that pgAudit may not be turned off"
  default     = {}

  validation {
    condition = alltrue([
      for name, value in var.database_flags :
      length(trimspace(name)) > 0 && length(trimspace(value)) > 0
    ])
    error_message = "var.database_flags keys and values must be non-empty strings"
  }

  validation {
    condition     = lookup(var.database_flags, "alloydb.enable_pgaudit", "on") == "on"
    error_message = "var.database_flags must not set alloydb.enable_pgaudit to anything but on; the module requires pgAudit to stay enabled"
  }
}

variable "backup_window" {
  type        = string
  description = "Duration of the automated backup window, as a protobuf duration"
  default     = "1800s"

  validation {
    condition     = can(regex("^[0-9]+s$", var.backup_window))
    error_message = "var.backup_window must be a duration in seconds, e.g. 1800s"
  }
}

variable "backup_start_hour" {
  type        = number
  description = "Hour of day (UTC) at which the automated backup window opens"
  default     = 2

  validation {
    condition     = var.backup_start_hour >= 0 && var.backup_start_hour <= 23
    error_message = "var.backup_start_hour must be between 0 and 23"
  }
}

variable "backup_days_of_week" {
  type        = list(string)
  description = "Days of the week on which automated backups run"
  default     = ["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"]

  validation {
    condition = length(var.backup_days_of_week) > 0 && alltrue([
      for day in var.backup_days_of_week :
      contains(["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"], day)
    ])
    error_message = "var.backup_days_of_week must be a non-empty list of upper-case day names"
  }
}

variable "maintenance_day" {
  type        = string
  description = "Day of the week on which Google may apply maintenance updates"
  default     = "SUNDAY"

  validation {
    condition     = contains(["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"], var.maintenance_day)
    error_message = "var.maintenance_day must be an upper-case day name"
  }
}

variable "maintenance_hour" {
  type        = number
  description = "Hour of day (UTC) at which the maintenance window opens. Keep it clear of var.backup_start_hour"
  default     = 3

  validation {
    condition     = var.maintenance_hour >= 0 && var.maintenance_hour <= 23
    error_message = "var.maintenance_hour must be between 0 and 23"
  }
}
