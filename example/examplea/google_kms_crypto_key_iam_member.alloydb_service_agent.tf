resource "google_kms_crypto_key_iam_member" "alloydb_service_agent" {
  crypto_key_id = google_kms_crypto_key.alloydb.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${google_project_service_identity.alloydb.email}"
}
