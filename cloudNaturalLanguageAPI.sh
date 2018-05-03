#!/bin/bash 

# Author: Sufyaan Kazi
# Date: April 2018
# Purpose: Use Google Cloud Natural Language API to extract information about people, places, events etc from text
#   and Speech API to analyse some speech
# https://google.qwiklabs.com/focuses/109?parent=catalog
# https://google.qwiklabs.com/focuses/115?parent=catalog

PROJECT_ID=`gcloud config list project --format "value(core.project)"`
SCRIPT_NAME=suf-gcloud-nlp

SERVICE_ACC=$SCRIPT_NAME@$PROJECT_ID
KEY_FILE=$PROJECT_ID-$SCRIPT_NAME.json

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

enableAPIS() {
  enableAPIIfNecessary iam.googleapis.com
  enableAPIIfNecessary cloudresourcemanager.googleapis.com
  enableAPIIfNecessary language.googleapis.com
  enableAPIIfNecessary speech.googleapis.com
}

gcloud auth login
gcloud config set project $PROJECT_ID
enableAPIS
createServiceAccount

echo "Calling Natural Language API"
# analyzeEntities analyzeEntitySentiment analyzeSentiment analyzeSyntax annotateText classifyText
curl "https://language.googleapis.com/v1/documents:analyzeEntities" -s -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $API_KEY" --data-binary @nlp_request.json
sleep 5

echo "Calling Speech API"
gcloud ml speech recognize 'gs://cloud-samples-tests/speech/brooklyn.flac' --language-code='en-US'
sleep 5

# Deleting Service Account
gcloud iam service-accounts delete -q $SERVICE_ACC.iam.gserviceaccount.com
