
resource "google_compute_network" "brcomputetfgcpvpc" {
  name                    = "${var.proj_name}-vpc"
  auto_create_subnetworks = true
}

resource "google_compute_firewall" "brcomputetfgcpfwssh" {
  name    = "${var.proj_name}-allow-ssh"
  network = google_compute_network.brcomputetfgcpvpc.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "brcomputetfgcpfwrstudio" {
  name    = "${var.proj_name}-allow-rstudio"
  network = google_compute_network.brcomputetfgcpvpc.name
  allow {
    protocol = "tcp"
    ports    = ["8787"]
  }
  source_ranges = ["0.0.0.0/0"]
}



