# Next '18 Networking Automation bootcamp: Lab4

Run this automation to complete many of the initial setup steps for lab 4,
Configuring an HTTP Load Balancer with Cloud Armor.

## What?

This Terraform configuration deploys:

*   1 Global HTTP Load Balancer
    *   with a backend services
    *   with 2 backends/Managed Instance Groups
    *   each in a different region: `us-central1` and `europe-west1`
*   1 VM instance for running siege.

By running the automation, skip the following tasks from the lab instructions:

*   Task 1: Configure HTTP and health check firewall rules
*   Task 2: Configure instance templates and create instance groups
*   Task 3: Configure the HTTP Load Balancer

## How?

*   Copy the code
    *   `git clone https://github.com/miketruty/next18labs.git`
    *   Change directory
    *   `pushd next18labs/lab4`
*   Setup Terraform binary
    *   `./get_terraform.sh`
    *   `[export command from get_terraform.sh output]`
    *   `terraform --help` to see Terraform working.
*   Set your project
    *   `gcloud config list project`
    *   `gcloud config set project [PROJECT-ID]`
    *   `./gcp_set_project.sh`
*   Setup GCP access credentials.
    *   Get the Compute Engine default service account
    *   `gcloud iam service-accounts list`
    *   The Compute Engine default service account ends with
        `-compute@developer.gserviceaccount.com`
    *   Create and downloads keys for that service account
        *   `gcloud iam service-accounts keys create ./credentials.json
            --iam-account [COMPUTE_ENGINE_EMAIL]`
    *   Set credentials.
        *   `./gcp_set_credentials.sh ./credentials.json`
*   Setup Terraform for this project
    *   `pushd terraform`
    *   `terraform init`
    *   `terraform validate`
*   Deploy the resources
    *   `terraform plan -out=tfplan -input=false`
    *   `terraform apply -input=false tfplan`
*   Note the IP addresses printed as output from the APPLY. They are needed to
    complete the remaining tasks in the lab.

Starting at Task 4: Test the HTTP Load Balancer, continue following the
instructions in Qwiklabs with the following notes:

*   Task 4

    *   At this time the automation does not create the LB_IP_v6.
    *   `siege-vm` is already created. Skip creating it.
    *   `siege` is already installed.

*   The remaining tasks proceed as written.
