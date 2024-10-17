output "brcomputetfgcpiip" {
  value = google_compute_instance.brcomputetfgcpvm.network_interface[0].access_config[0].nat_ip
}
