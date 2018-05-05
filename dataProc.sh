#!/bin/bash 

# Author: Sufyaan Kazi
# Date: April 2018
# Purpose: Demonstrate the ability to spin up (and down) a DataProc cluster
# It spins up a DataProc cluster and starts a PSark job to calculate Pi
# How the job calculates Pi: The Spark job estimates a value of Pi using the Monte Carlo method. It generates x,y points on a coordinate plane that models a circle enclosed by a unit square.
# The input argument (1000) determines the number of x,y pairs to generate; the more pairs generated, the greater the accuracy of the estimation.
# This estimation leverages Cloud Dataproc worker nodes to parallelize the computation.
# For more information, see Estimating Pi using the Monte Carlo Method and see JavaSparkPi.java on GitHub.

. ./common.sh

enableAPIIfNecessary dataproc.googleapis.com

gcloud dataproc clusters create example-cluster --num-workers=2 --zone=europe-west2-b
gcloud dataproc jobs submit spark --cluster example-cluster   --class org.apache.spark.examples.SparkPi   --jars file:///usr/lib/spark/examples/jars/spark-examples.jar -- 1000

#gcloud dataproc clusters update example-cluster --num-workers 5

#gcloud dataproc clusters delete example-cluster -q
