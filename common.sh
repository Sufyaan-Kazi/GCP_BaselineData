#!/bin/bash 

# Author: Sufyaan Kazi
# Date: April 2018

enableAPIIfNecessary() {
  API_EXISTS=`gcloud services list | grep $1 | wc -l`

  if [ $API_EXISTS -eq 0 ]
  then
    gcloud services enable $1
  fi
}

createServiceAccount() {
  # Alternately set the API Key env to value defined in the Console (Credntials, Create Credentials)
  gcloud iam service-accounts create $SCRIPT_NAME --display-name=$SCRIPT_NAME
  gcloud projects add-iam-policy-binding $PROJECT_ID --member "serviceAccount:$SERVICE_ACC.iam.gserviceaccount.com" --role "roles/owner"
  gcloud iam service-accounts keys create $KEY_FILE --iam-account $SERVICE_ACC.iam.gserviceaccount.com
  gcloud auth activate-service-account --key-file $KEY_FILE
  API_KEY=$(gcloud auth print-access-token)
  rm -rf $KEY_FILE
}
