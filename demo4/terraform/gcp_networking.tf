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
 * Terraform networking resources for GCP.
 */

// ----------untrust vpc----------
resource "google_compute_network" "untrust-vpc" {
  name                    = "untrust-vpc"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "untrust-subnet" {
  name          = "untrust-subnet"
  ip_cidr_range = "10.0.1.0/24"
  network       = "${google_compute_network.untrust-vpc.self_link}"
  region        = "${var.gcp_region}"
}

// ----------onprem vpc----------
resource "google_compute_network" "onprem-vpc" {
  name                    = "onprem-vpc"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "onprem-subnet" {
  name          = "onprem-subnet"
  ip_cidr_range = "10.0.0.0/24"
  network       = "${google_compute_network.onprem-vpc.self_link}"
  region        = "${var.gcp_region}"
}

// ----------trust vpc----------
resource "google_compute_network" "trust-vpc" {
  name                    = "trust-vpc"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "trust-subnet" {
  name          = "trust-subnet"
  ip_cidr_range = "10.0.2.0/24"
  network       = "${google_compute_network.trust-vpc.self_link}"
  region        = "${var.gcp_region}"
}

// ----------static route----------
resource "google_compute_route" "trust-route" {
  name                   = "trust-route"
  dest_range             = "0.0.0.0/0"
  network                = "${google_compute_network.trust-vpc.self_link}"
  next_hop_instance      = "${element(google_compute_instance.firewall-vm.*.name,count.index)}"
  next_hop_instance_zone = "${var.gcp_region_zone}"
  priority               = 100

  depends_on = [
    "google_compute_network.untrust-vpc",
    "google_compute_network.onprem-vpc",
    "google_compute_network.trust-vpc",
    "google_compute_instance.firewall-vm",
    "google_container_cluster.primary-gkecluster",
  ]
}

// ----------GLOBAL HTTP LB SETUP----------
module "gclb-lb-http" {
  source      = "GoogleCloudPlatform/lb-http/google"
  version     = "1.0.4"
  name        = "gclb-lb-http"
  target_tags = ["${var.tags_fw}"]

  network = "${google_compute_network.untrust-vpc.self_link}"
  region  = "${var.gcp_region}"

  backends = {
    "0" = [
      {
        # group = "${google_compute_instance_group.gw-ig.instance_group}"
        group = "${google_compute_instance_group.fw-ig.self_link}"
      },
    ]
  }

  backend_params = [
    // health check path, port name, port number, timeout seconds.
    "/,http,80,10",
  ]
}
