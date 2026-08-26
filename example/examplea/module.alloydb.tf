# holden:ignore:HLD_TF_026 — examples intentionally use ../../ to reference the local module root
# holden:ignore:HLD_TF_065: for expansion
module "alloydb" {
  source       = "../../"
  cluster_id   = "example-cluster"
  instance_id  = "example-primary"
  location     = "europe-west2"
  network      = "projects/${data.google_project.current.number}/global/networks/${google_compute_network.alloydb.name}"
  kms_key_name = google_kms_crypto_key.alloydb.id

  depends_on = [
    google_service_networking_connection.alloydb,
    google_kms_crypto_key_iam_member.alloydb_service_agent,
  ]
}
