#! /bin/bash

for cluster in $(gcloud container clusters list --format="value(name)" --project $PROJECT)
do
   gcloud container clusters get-credentials $cluster --zone $ZONE --project $PROJECT
   kubectl annotate serviceaccount --namespace $K8NS $KSA iam.gke.io/gcp-service-account=$GSA@$PROJECT.iam.gserviceaccount.com
   echo "=================================================="
   kubectl run \
  --generator=run-pod/v1 \
  --image google/cloud-sdk \
  --serviceaccount $KSA \
  --namespace $K8NS \
  workload-identity-test \
  -- echo $(gcloud auth list)
   echo "=================================================="
done
