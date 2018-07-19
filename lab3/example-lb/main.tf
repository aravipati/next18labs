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

provider google {
  version = "~> 1.16.0"

  credentials = "${file("${var.gcp_credentials_file_path}")}"

  # Should be able to parse project from credentials file but cannot.
  # Cannot convert string to map and cannot interpolate within variables.
  project = "${var.gcp_project_id}"

  region = "${var.gcp_region}"
}

data "template_file" "group1-startup-script" {
  template = "${file("${format("%s/gceme.sh.tpl", path.module)}")}"

  vars {
    PROXY_PATH = ""
  }
}

module "nlb-mig1" {
  source            = "GoogleCloudPlatform/managed-instance-group/google"
  version           = "1.1.8"
  region            = "${var.gcp_region}"
  zone              = "${var.gcp_zone}"
  name              = "nlb-group1"
  size              = 2
  service_port      = 80
  service_port_name = "http"
  target_pools      = ["${module.nlb-gce-lb-fr.target_pool}"]
  target_tags       = ["allow-service1"]
  startup_script    = "${data.template_file.group1-startup-script.rendered}"
}

module "nlb-gce-lb-fr" {
  source       = "GoogleCloudPlatform/lb/google"
  version      = "1.0.2"
  region       = "${var.gcp_region}"
  name         = "nlb-group1-lb"
  service_port = "${module.nlb-mig1.service_port}"
  target_tags  = ["${module.nlb-mig1.target_tags}"]
}
