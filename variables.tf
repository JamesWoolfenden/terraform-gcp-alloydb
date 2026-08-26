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
  description = "Self-link of the VPC network the cluster attaches to, e.g. projects/<project-number>/global/networks/<name>"

  validation {
    condition     = can(regex("^projects/[^/]+/global/networks/[^/]+$", var.network))
    error_message = "var.network must be of the form projects/<project>/global/networks/<name>"
  }
}

variable "kms_key_name" {
  type        = string
  description = "Resource name of the Cloud KMS key used to encrypt the cluster, its backups and its continuous backups (CMEK)"
  sensitive   = true

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
