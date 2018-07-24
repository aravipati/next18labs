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
 * Terraform GKE cluster setup
 */

resource "google_container_cluster" "primary-gkecluster" {
  name = "primary-gkecluster"
  zone = "${var.gcp_region_zone}"

  initial_node_count = 1

  additional_zones = "${var.gke_additional_zones}"

  network    = "${google_compute_network.trust-vpc.name}"
  subnetwork = "${google_compute_subnetwork.trust-subnet.name}"

  master_auth {
    username = "admin"
    password = "Your_password_here"
  }

  node_config {
    machine_type = "f1-micro"

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}
