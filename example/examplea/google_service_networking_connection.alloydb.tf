resource "google_service_networking_connection" "alloydb" {
  network                 = google_compute_network.alloydb.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.alloydb.name]
  deletion_policy         = "ABANDON"
}
