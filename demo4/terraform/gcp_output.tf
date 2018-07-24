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
 * Terraform outputs.
 */

output "firewall-vm-name" {
  value = "${google_compute_instance.firewall-vm.*.name}"
}

output "firewall-untrust-ips-for-nat-healthcheck" {
  value = "${google_compute_instance.firewall-vm.*.network_interface.0.address}"
}

output "gclb-public-ip" {
  value = "${google_compute_global_forwarding_rule.default.ip_address}"
  value = "${module.gclb-lb-http.external_ip}"
}

output "cluster-name" {
  value = "${google_container_cluster.primary-gkecluster.name}"
}

output "cluster-primary-zone" {
  value = "${google_container_cluster.primary-gkecluster.zone}"
}

output "cluster-additional-zones" {
  value = "${google_container_cluster.primary-gkecluster.additional_zones}"
}

output "cluster-node-version" {
  value = "${google_container_cluster.primary-gkecluster.node_version}"
}
