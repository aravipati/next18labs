# Next '18 Networking Automation bootcamp: Lab5

Run this automation to complete many of the initial setup steps for
lab 5, Analyzing network traffic with VPC Flow Logs.

## What?

This Terraform configuration deploys:

*  1 custom mode VPC with subnet.
*  1 allow firewall rule.
*  1 VM instance for generating flow logs.

By running the automation, skip the following tasks from the lab instructions:

*  Task 1: Configure a custom network with VPC Flow Logs
*  Task 2: Create an Apache web server

## How?

*  Copy the code
   * `git clone https://github.com/miketruty/next18labs.git`
   *   Change directory
   *   `pushd next18labs/lab5`
*  Setup Terraform binary
   *   `./get_terraform.sh`
   *   `[export command from get_terraform.sh output]`
   *   `terraform --help` to see Terraform working.
*  Set your project
   *   `gcloud config list project`
   *   `gcloud config set project [PROJECT-ID]`
   *   `./gcp_set_project.sh`
*  Setup GCP access credentials.
   *   Get the Compute Engine default service account
   *   `gcloud iam service-accounts list`
   *   The Compute Engine default service account ends with
       `-compute@developer.gserviceaccount.com`
   *   Create and downloads keys for that service account
       *  `gcloud iam service-accounts keys create ./credentials.json --iam-account [COMPUTE_ENGINE_EMAIL]`
   *   Set credentials.
       *  `./gcp_set_credentials.sh ./credentials.json`
*  Setup Terraform for this project
   *  `pushd terraform`
   *  `terraform init`
   *  `terraform validate`
*  Deploy the resources
   *  `terraform plan -out=tfplan -input=false`
   *  `terraform apply -input=false tfplan`
*  Note the IP address printed as output from the APPLY. It is needed
   to complete the remaining tasks in the lab.

Starting at Task 3: Verify that network traffic is logged,
follow the remaining lab instructions in Qwiklabs.
