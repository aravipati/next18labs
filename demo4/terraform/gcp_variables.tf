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
 * Terraform variable declarations for GCP.
 */

variable gcp_credentials_file_path {
  description = "Locate the GCP credentials .json file."
  type        = "string"
}

variable gcp_project_id {
  description = "GCP Project ID."
  type        = "string"
}

variable gcp_region {
  description = "Default to Oregon region."
  default     = "us-west1"
}

variable gcp_region_zone {
  default = "us-west1-a"
}

variable machine_type_fw {
  default = "n1-standard-4"
}

variable zone_fw {
  type    = "list"
  default = ["us-west1-a"]
}

variable tags_fw {
  type    = "list"
  default = ["firewall-vm-tag"]
}

variable image_fw {
  default = "https://www.googleapis.com/compute/v1/projects/debian-cloud/global/images/debian-9-stretch-v20180611"
}

variable gke_additional_zones {
  type = "list"

  default = [
    "us-west1-b",
    "us-west1-c",
  ]
}
