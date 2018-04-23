#!/bin/bash 

# Author: Sufyaan Kazi
# Date: April 2018
# Purpose: Demonstrate the ability to spin up (and down) a DataProc cluster
# It spins up a DataProc cluster and starts a PSark job to calculate Pi

gcloud dataproc clusters delete example-cluster -q

gcloud dataproc clusters create example-cluster --num-workers=5
gcloud dataproc jobs submit spark --cluster example-cluster   --class org.apache.spark.examples.SparkPi   --jars file:///usr/lib/spark/examples/jars/spark-examples.jar -- 1000

gcloud dataproc clusters update example-cluster --num-workers 2

gcloud dataproc clusters delete example-cluster -q
