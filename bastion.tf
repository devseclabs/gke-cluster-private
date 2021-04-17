resource "google_compute_instance" "default" {
  name         = "${var.prefix}-bastion"
  project    = var.project_id
  machine_type = "f1-micro"
  zone         = "us-central1-a"

  tags = [var.prefix, "bastion"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = module.gcp-network.network_self_link
    subnetwork = module.gcp-network.subnets_self_links[0]

    access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    foo = "bar"
  }
 
}

resource "google_compute_firewall" "default" {
  name    = "${var.prefix}-ssh-firewall"
  project    = var.project_id
  network = module.gcp-network.network_name

  allow {
    protocol = "tcp"
    ports    = ["22", "8888"]
  }
  source_ranges = [ "0.0.0.0/0" ]

  target_tags = [var.prefix,"web"]
}
