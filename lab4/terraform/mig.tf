/*
 * Copyright 2017 Google Inc.
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

data "template_file" "group-startup-script" {
  template = "${file("${format("%s/startup.sh.tpl", path.module)}")}"

  vars {
    PROXY_PATH = ""
  }
}

module "us-central1-mig" {
  source            = "GoogleCloudPlatform/managed-instance-group/google"
  version           = "1.1.10"
  region            = "${var.gcp_region}"
  zone              = "${var.gcp_zone}"
  network           = "${var.gcp_network}"
  name              = "us-central1-mig"
  wait_for_instances = true
  autoscaling        = true

  autoscaling_cpu = [{
    target = 0.8
  }]

  size              = 1
  min_replicas      = 1
  max_replicas      = 5
  cooldown_period   = 45
  compute_image     = "${var.compute_image}"
  target_tags       = ["${var.target_tags}"]
  service_port      = 80
  service_port_name = "http"
  startup_script    = "${data.template_file.group-startup-script.rendered}"
}

module "europe-west1-mig" {
  source            = "GoogleCloudPlatform/managed-instance-group/google"
  version           = "1.1.10"
  region            = "${var.gcp_region2}"
  zone              = "${var.gcp_zone2}"
  network           = "${var.gcp_network}"
  name              = "europe-west1-mig"
  wait_for_instances = true
  autoscaling        = true

  autoscaling_cpu = [{
    target = 0.8
  }]

  size              = 1
  min_replicas      = 1
  max_replicas      = 5
  cooldown_period   = 45
  compute_image     = "${var.compute_image}"
  target_tags       = ["${var.target_tags}"]
  service_port      = 80
  service_port_name = "http"
  startup_script    = "${data.template_file.group-startup-script.rendered}"
}
