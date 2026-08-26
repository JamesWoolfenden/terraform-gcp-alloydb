# terraform-gcp-alloydb

[![Build Status](https://github.com/JamesWoolfenden/terraform-gcp-alloydb/workflows/Verify/badge.svg?branch=master)](https://github.com/JamesWoolfenden/terraform-gcp-alloydb)
[![Latest Release](https://img.shields.io/github/release/JamesWoolfenden/terraform-gcp-alloydb.svg)](https://github.com/JamesWoolfenden/terraform-gcp-alloydb/releases/latest)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/tag/JamesWoolfenden/terraform-gcp-alloydb.svg?label=latest)](https://github.com/JamesWoolfenden/terraform-gcp-alloydb/releases/latest)
![Terraform Version](https://img.shields.io/badge/tf-%3E%3D1.5.0-blue.svg)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)

Terraform module for a private, CMEK-encrypted AlloyDB cluster with a primary
instance and an on-demand backup. Exercises holden's `google_alloydb_cluster`,
`google_alloydb_instance` and `google_alloydb_backup` policies.

## Usage

Add **module.alloydb.tf** to your code:-

```terraform
module "alloydb" {
  source       = "jameswoolfenden/alloydb/gcp"
  version      = "0.0.1"
  cluster_id   = "example-cluster"
  instance_id  = "example-primary"
  location     = "europe-west2"
  network      = "projects/${data.google_project.current.number}/global/networks/${google_compute_network.alloydb.name}"
  kms_key_name = google_kms_crypto_key.alloydb.id
}
```

The cluster is created with deletion protection, continuous backup (CMEK
encrypted) and an automated backup policy. The primary instance has
`enable_public_ip = false`, so the calling configuration must provide private
services access on the supplied network — see `example/examplea` for the
`google_compute_global_address` / `google_service_networking_connection` pair.

The AlloyDB service agent needs
`roles/cloudkms.cryptoKeyEncrypterDecrypter` on the supplied key before the
cluster can be created; the example grants it.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [google_alloydb_backup.nightly](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/alloydb_backup) | resource |
| [google_alloydb_cluster.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/alloydb_cluster) | resource |
| [google_alloydb_instance.primary](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/alloydb_instance) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_backup_days_of_week"></a> [backup\_days\_of\_week](#input\_backup\_days\_of\_week) | Days of the week on which automated backups run | `list(string)` | <pre>[<br/>  "MONDAY",<br/>  "TUESDAY",<br/>  "WEDNESDAY",<br/>  "THURSDAY",<br/>  "FRIDAY",<br/>  "SATURDAY",<br/>  "SUNDAY"<br/>]</pre> | no |
| <a name="input_backup_retention_count"></a> [backup\_retention\_count](#input\_backup\_retention\_count) | Number of automated backups to retain | `number` | `14` | no |
| <a name="input_backup_start_hour"></a> [backup\_start\_hour](#input\_backup\_start\_hour) | Hour of day (UTC) at which the automated backup window opens | `number` | `2` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | Duration of the automated backup window, as a protobuf duration | `string` | `"1800s"` | no |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Identifier of the AlloyDB cluster | `string` | n/a | yes |
| <a name="input_cpu_count"></a> [cpu\_count](#input\_cpu\_count) | vCPU count of the primary instance | `number` | `2` | no |
| <a name="input_database_flags"></a> [database\_flags](#input\_database\_flags) | Additional PostgreSQL database flags, merged over the module's baseline (pgaudit and password complexity). Keys given here win, except that pgAudit may not be turned off | `map(string)` | `{}` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Whether the cluster is protected from deletion | `bool` | `true` | no |
| <a name="input_instance_id"></a> [instance\_id](#input\_instance\_id) | Identifier of the AlloyDB primary instance | `string` | n/a | yes |
| <a name="input_kms_key_name"></a> [kms\_key\_name](#input\_kms\_key\_name) | Resource name of the Cloud KMS key used to encrypt the cluster, its backups and its continuous backups (CMEK) | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Region of the AlloyDB cluster | `string` | `"europe-west2"` | no |
| <a name="input_maintenance_day"></a> [maintenance\_day](#input\_maintenance\_day) | Day of the week on which Google may apply maintenance updates | `string` | `"SUNDAY"` | no |
| <a name="input_maintenance_hour"></a> [maintenance\_hour](#input\_maintenance\_hour) | Hour of day (UTC) at which the maintenance window opens. Keep it clear of var.backup\_start\_hour | `number` | `3` | no |
| <a name="input_network"></a> [network](#input\_network) | Self-link of the VPC network the cluster attaches to, e.g. projects/<project-number>/global/networks/<name> | `string` | n/a | yes |
| <a name="input_recovery_window_days"></a> [recovery\_window\_days](#input\_recovery\_window\_days) | Continuous backup recovery window, in days | `number` | `14` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_backup_id"></a> [backup\_id](#output\_backup\_id) | ID of the on-demand AlloyDB backup |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | ID of the AlloyDB cluster |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Name of the AlloyDB cluster |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | ID of the AlloyDB primary instance |
| <a name="output_instance_ip_address"></a> [instance\_ip\_address](#output\_instance\_ip\_address) | Private IP address of the AlloyDB primary instance |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Related Projects

Check out these related projects.

- [terraform-gcp-cloudsql](https://github.com/JamesWoolfenden/terraform-gcp-cloudsql) - Cloud SQL

## Help

**Got a question?**

File a GitHub [issue](https://github.com/JamesWoolfenden/terraform-gcp-alloydb/issues).

## Copyrights

Copyright © 2019-2026 [Jim Woolfenden](https://github.com/JamesWoolfenden)

## License

See [LICENSE](LICENSE) for full details.

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [google_alloydb_backup.nightly](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/alloydb_backup) | resource |
| [google_alloydb_cluster.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/alloydb_cluster) | resource |
| [google_alloydb_instance.primary](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/alloydb_instance) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_backup_days_of_week"></a> [backup\_days\_of\_week](#input\_backup\_days\_of\_week) | Days of the week on which automated backups run | `list(string)` | <pre>[<br/>  "MONDAY",<br/>  "TUESDAY",<br/>  "WEDNESDAY",<br/>  "THURSDAY",<br/>  "FRIDAY",<br/>  "SATURDAY",<br/>  "SUNDAY"<br/>]</pre> | no |
| <a name="input_backup_retention_count"></a> [backup\_retention\_count](#input\_backup\_retention\_count) | Number of automated backups to retain | `number` | `14` | no |
| <a name="input_backup_start_hour"></a> [backup\_start\_hour](#input\_backup\_start\_hour) | Hour of day (UTC) at which the automated backup window opens | `number` | `2` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | Duration of the automated backup window, as a protobuf duration | `string` | `"1800s"` | no |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Identifier of the AlloyDB cluster | `string` | n/a | yes |
| <a name="input_cpu_count"></a> [cpu\_count](#input\_cpu\_count) | vCPU count of the primary instance | `number` | `2` | no |
| <a name="input_database_flags"></a> [database\_flags](#input\_database\_flags) | Additional PostgreSQL database flags, merged over the module's baseline (pgaudit and password complexity). Keys given here win, except that pgAudit may not be turned off | `map(string)` | `{}` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Whether the cluster is protected from deletion | `bool` | `true` | no |
| <a name="input_instance_id"></a> [instance\_id](#input\_instance\_id) | Identifier of the AlloyDB primary instance | `string` | n/a | yes |
| <a name="input_kms_key_name"></a> [kms\_key\_name](#input\_kms\_key\_name) | Resource name of the Cloud KMS key used to encrypt the cluster, its backups and its continuous backups (CMEK) | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Region of the AlloyDB cluster | `string` | `"europe-west2"` | no |
| <a name="input_maintenance_day"></a> [maintenance\_day](#input\_maintenance\_day) | Day of the week on which Google may apply maintenance updates | `string` | `"SUNDAY"` | no |
| <a name="input_maintenance_hour"></a> [maintenance\_hour](#input\_maintenance\_hour) | Hour of day (UTC) at which the maintenance window opens. Keep it clear of var.backup\_start\_hour | `number` | `3` | no |
| <a name="input_network"></a> [network](#input\_network) | Self-link of the VPC network the cluster attaches to, e.g. projects/<project-number>/global/networks/<name> | `string` | n/a | yes |
| <a name="input_recovery_window_days"></a> [recovery\_window\_days](#input\_recovery\_window\_days) | Continuous backup recovery window, in days | `number` | `14` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_backup_id"></a> [backup\_id](#output\_backup\_id) | ID of the on-demand AlloyDB backup |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | ID of the AlloyDB cluster |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Name of the AlloyDB cluster |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | ID of the AlloyDB primary instance |
| <a name="output_instance_ip_address"></a> [instance\_ip\_address](#output\_instance\_ip\_address) | Private IP address of the AlloyDB primary instance |
<!-- END_TF_DOCS -->


<!-- BEGINNING OF PRE-COMMIT-PIKE DOCS HOOK -->
The Terraform resource required is:

```golang
# apply role
resource "google_project_iam_custom_role" "terraform_pike" {
  project     = "pike-477416"
  role_id     = "terraform_pike"
  title       = "terraform_pike"
  description = "A user with least privileges"
  permissions = [
    "alloydb.backups.create",
    "alloydb.backups.delete",
    "alloydb.backups.get",
    "alloydb.backups.update",
    "alloydb.clusters.create",
    "alloydb.clusters.delete",
    "alloydb.clusters.get",
    "alloydb.clusters.update",
    "alloydb.instances.create",
    "alloydb.instances.delete",
    "alloydb.instances.get",
    "alloydb.instances.update",
    "alloydb.operations.get"
  ]
}

# plan role
resource "google_project_iam_custom_role" "terraform_pike_plan" {
  project     = "pike-477416"
  role_id     = "terraform_pike_plan"
  title       = "terraform_pike_plan"
  description = "A user with least privileges"
  permissions = [
    "alloydb.backups.get",
    "alloydb.clusters.get",
    "alloydb.instances.get",
    "alloydb.operations.get"
  ]
}


```
<!-- END OF PRE-COMMIT-PIKE DOCS HOOK -->