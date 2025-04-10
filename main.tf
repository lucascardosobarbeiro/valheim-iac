provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "valheim_net" {
  name = "valheim-network"
}

resource "google_compute_firewall" "valheim_fw" {
  name    = "valheim-firewall"
  network = google_compute_network.valheim_net.self_link

  allow {
    protocol = "udp"
    ports    = ["2456-2458"]
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "valheim_vm" {
  name         = var.vm_name
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 20
    }
  }

  network_interface {
    network = google_compute_network.valheim_net.name
    access_config {}
  }

  metadata_startup_script = file("${path.module}/startup.sh")

  tags = ["valheim"]
}
