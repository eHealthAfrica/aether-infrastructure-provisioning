# Aether infrastructure provisioning
Terraform and associated files for provisioning a Kubernetes cluster for a Aether based deployment

### Requirements

* Google Cloud Account [https://cloud.google.com/gcp](https://cloud.google.com/gcp)
* Domain hosted in Google's Cloud DNS or AWS's Route53
* Terraform > 'v0.11.10' [Download Teraform](https://www.terraform.io/downloads.html)
* Kubectl [Download Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* aether-helm-generator ```pip install aether-helm-generator)```

### Steps

* First of clone the repository
	```git clone git@github.com:eHealthAfrica/aether-infrastructure-provisioning.git```
* ```cd aether-infrastructure-provisioning/examples```
* Edit the ```vars.tf``` and update the variables with your own details
* ```terraform init && terraform apply```
