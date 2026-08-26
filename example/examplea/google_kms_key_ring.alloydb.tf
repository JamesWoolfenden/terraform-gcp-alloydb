resource "google_kms_key_ring" "alloydb" {
  name     = "alloydb-keyring"
  location = "europe-west2"
}
