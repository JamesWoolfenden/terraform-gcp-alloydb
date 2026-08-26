resource "google_project_service_identity" "alloydb" {
  provider = google-beta
  service  = "alloydb.googleapis.com"

  depends_on = [google_project_service.alloydb]
}
