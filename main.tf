variable "project_id" {
  description = "The GCP project ID to deploy resources"
}
variable "project_name" {
  description = "The GCP project name to deploy resources"
}

variable "billing_ac_id" {
  description = "The GCP billing account ID to be configured with project"
}
resource "google_project" "my_project" {
  name       = "${var.project_name}"
  project_id = "${var.project_id}"
  billing_account = "${var.billing_ac_id}"
}
resource "google_project_service" "my_project_api" {
  project = "${google_project.my_project.project_id}"
  service = "compute.googleapis.com"

  disable_dependent_services = true
}
resource "google_compute_instance" "default" {
  project      = "${google_project.my_project.project_id}"
  name         = "terraform"
  machine_type = "f1-micro"
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
  depends_on = ["google_project_service.my_project_api"]
}
output "machinename" {
  value = "${google_compute_instance.default.name}"
}