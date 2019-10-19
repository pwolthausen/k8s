# Testing stability of Workload Identiy

Using deployment manager to create, update and delete up to 4 clusters at a time to test whether wid is working correctly
NOTE: because clusters use up large amounts of IP blocks, the deployment manager manifest will create a new VPC network along with a subnet and 5 secondary ranges. Make sure your project allows you to create these resources. The VPC and the resources within are isolated.

Before you begin, export the following variables
- GSA: name of the Google service account
- KSA: name of the k8s service account
- K8NS: name of the namespace to test workload identity in
- ZONE: this will be the same zone you set in the `location` field
- PROJECT: the project ID where you are deploying the clusters

1. Create clusters using Workload Identity, also includes the namespace to test in and a service account. Make sure the `initialVersion` field is using a supported GKE version.

> gcloud deployment-manager deployments create wid-test --config wid-cluster.yaml --project $PROJECT

2. Once the clusters have been created, update them. Edit the wid-cluster.yaml file, un-comment the `newVersion` field add a newer, supported version of k8s

3. Update the deployment to update the clusters and wait for the process to complete

> gcloud deployment-manager deployments update wid-test --config wid-cluster.yaml --project $PROJECT

4. Create a Google service account

> gcloud iam service-accounts create $GSA

5. Link the GSA and the KSA

> gcloud iam service-accounts add-iam-policy-binding \
  --role roles/iam.workloadIdentityUser \
  --member "serviceAccount:$PROJECT.svc.id.goog[$K8NS/$KSA]" \
  $GSA@$PROJECT.iam.gserviceaccount.com

6. Test the workload identity of each cluster using the provided bash script

7. Clean up by deleting the deployment

> gcloud deployment-manager deployments delete wid-test --project $PROJECT
