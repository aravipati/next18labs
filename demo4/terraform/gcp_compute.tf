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

// Create a new firewall VM instance
resource "google_compute_instance" "firewall-vm" {
  name         = "firewall-vm-${count.index + 1}"
  machine_type = "${var.machine_type_fw}"
  zone         = "${element(var.zone_fw, count.index)}"
  tags         = ["${var.tags_fw}"]

  can_ip_forward = true

  allow_stopping_for_update = true
  count                     = 2

  boot_disk {
    initialize_params {
      image = "${var.image_fw}"
    }
  }

  network_interface {
    subnetwork    = "${google_compute_subnetwork.untrust-subnet.self_link}"
    access_config = {}
  }

  network_interface {
    subnetwork    = "${google_compute_subnetwork.onprem-subnet.self_link}"
    access_config = {}
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.trust-subnet.self_link}"
  }

  metadata_startup_script = "${file("vm_userdata.sh")}"
}

resource "google_compute_instance_group" "fw-ig" {
  name = "fw-ig"

  instances = ["${google_compute_instance.firewall-vm.*.self_link}"]

  named_port {
    name = "http"
    port = "80"
  }
}
