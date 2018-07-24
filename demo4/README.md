# Instructions for running the Next '18 automation bootcamp demo4.

## What?

This demo creates:

*   3 VPCs: `untrust-vpc`, `trust-vpc`, and `onprem-vpc`.
*   2 VM instances, with MultiNic, acting as NGFW `firewall-vm-1` and
    `firewall-vm-2` in zone `us-west1-a` (Oregon).
*   1 GKE cluster named `primary-gkecluster` with a node running in each of
    `us-west1-a`, `us-west1-b`, and `us-west1-c`.
*   1 Global HTTP load balancer to handle the public IP.
*   GKE also creates a regional TCP network load balancer in `trust-vpc` in
    `us-west1`.

## How?

*   Copy the code
    *   `git clone https://github.com/miketruty/next18labs`
    *   Change directory
    *   `pushd next18labs/demo4`
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
*   Check resources deployed
    *   `terraform output`
*   Run the serving application in GKE
    *   `gcloud container clusters get-credentials primary-gkecluster --zone
        us-west1-a --project [TARGET_PROJECT]`
    *   `kubectl run hello-server --image gcr.io/google-samples/hello-app:1.0
        --port 8080`
    *   `kubectl apply -f hello-config.yaml`
*   Test the serving application
    *   `terraform output` to get `[GCLB-PUBLIC-IP]`
    *   `curl [GCLB-PUBLIC-IP]`
    *   You should see `Hello, world!` and some other informaiton.
*   Clean up
    *   The GKE service.
        *   `kubectl delete service hello-server`
        *   The `hello-server` service causes GKE to add 2 firewall rules. As
            part of clean up, you need to wait for those 2 rules to be deleted
            before running `terraform destroy`. Use the following command to
            check and wait until there are only 4 firewall rules shown. It can
            take upto 45 seconds for these deletions.
        *   `gcloud compute firewall-rules list --filter NETWORK=trust-vpc`
    *   `terraform destroy` - you need to approve with `yes`
