provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "valheim_net" {
  name                    = "valheim-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "valheim_subnet" {
  name          = "valheim-subnet"
  ip_cidr_range = "10.10.0.0/24"
  region        = var.region
  network       = google_compute_network.valheim_net.id
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
  target_tags   = ["valheim"]
}

resource "google_compute_address" "valheim_static_ip" {
  name   = "valheim-ip"
  region = var.region
}

resource "google_compute_disk" "valheim_boot_disk" {
  name  = "${var.vm_name}-boot-disk"
  type  = "pd-standard"
  zone  = var.zone
  size  = 20

  image = "ubuntu-os-cloud/ubuntu-2204-lts"
}

resource "google_compute_instance" "valheim_vm" {
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    source = google_compute_disk.valheim_boot_disk.id
  }

  network_interface {
    network    = google_compute_network.valheim_net.id
    subnetwork = google_compute_subnetwork.valheim_subnet.id
    access_config {
      nat_ip = google_compute_address.valheim_static_ip.address
    }
  }

  tags = ["valheim"]

  metadata = {
    enable-oslogin = "TRUE"
  }

  metadata_startup_script = templatefile("startup_script.tmpl", {
    server_name     = var.server_name
    world_name      = var.world_name
    server_password = var.server_password
    project_id      = var.project_id
    zone            = var.zone
    instance_name   = var.vm_name
  })

  service_account {
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  labels = {
    game = "valheim"
    env  = "prod"
  }
}

resource "google_compute_resource_policy" "valheim_snapshots" {
  name   = "valheim-daily-snapshot"
  region = var.region

  snapshot_schedule_policy {
    schedule {
      daily_schedule {
        days_in_cycle = 1
        start_time    = "03:00"
      }
    }

    retention_policy {
      max_retention_days    = 7
      on_source_disk_delete = "KEEP_AUTO_SNAPSHOTS"
    }

    snapshot_properties {
      labels = {
        backup = "true"
      }
    }
  }
}

resource "google_compute_disk_resource_policy_attachment" "valheim_disk_policy" {
  name = google_compute_resource_policy.valheim_snapshots.name
  disk = google_compute_disk.valheim_boot_disk.name
  zone = var.zone
  depends_on = [google_compute_instance.valheim_vm]
}