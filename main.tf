variable "project_id" {
  description = "The GCP project to deploy resources"
}
resource "google_compute_instance" "default" {
  project      = "${var.project_id}"
  name         = "terraform"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }
}
output "machinename" {
  value = "${google_compute_instance.default.name}"
}
output "hostpip" {
  value = "${google_compute_instance.default.network_interface-0-access_config-0-nat_ip}"
}