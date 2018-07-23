/*
 * Copyright 2018 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*
 * Terraform compute resources for GCP.
 */

resource "google_compute_instance" "siege-vm" {
  name         = "siege-vm"
  machine_type = "${var.gcp_siege_instance_type}"
  zone         = "${var.gcp_siege_zone}"

  boot_disk {
    initialize_params {
      image = "${var.compute_image}"
    }
  }

  network_interface {
    subnetwork = "${var.gcp_network}"

    access_config {
      # Ephemeral IP
    }
  }

  metadata_startup_script = "${file("siege_startup.sh.tpl")}"
}
