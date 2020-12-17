#!/bin/bash 
# Copyright 2018 Google LLC. This software is provided as-is, without warranty or representation for any use or purpose. Your use of it is subject to your agreements with Google.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# “Copyright 2018 Google LLC. This software is provided as-is, without warranty or representation for any use or purpose.
#  Your use of it is subject to your agreements with Google.”
#

# Author: Sufyaan Kazi
# Date: April 2018
# Purpose: Demonstrate the ability to spin up (and down) a DataProc cluster
# It spins up a DataProc cluster and starts a PSark job to calculate Pi
# How the job calculates Pi: The Spark job estimates a value of Pi using the Monte Carlo method.
# It generates x,y points on a coordinate plane that models a circle enclosed by a unit square.
# Once the job completes, click on it's logs, turn on line wrapping and you will see Pi calculated!
#
# The input argument (1000) determines the number of x,y pairs to generate; the more pairs generated, the greater the accuracy of the estimation.
# This estimation leverages Cloud Dataproc worker nodes to parallelize the computation.
# For more information, see Estimating Pi using the Monte Carlo Method and see JavaSparkPi.java on GitHub.

#. ./common.sh

#enableAPIs dataproc.googleapis.com

gcloud config set dataproc/region europe-west2
gcloud dataproc clusters create example-cluster --num-workers=2 --zone=europe-west2-b
gcloud dataproc jobs submit spark --cluster example-cluster   --class org.apache.spark.examples.SparkPi   --jars file:///usr/lib/spark/examples/jars/spark-examples.jar -- 1000

#gcloud dataproc clusters update example-cluster --num-workers 5

gcloud dataproc clusters delete example-cluster -q

#TO DO
#Add logic to delete the dataproc buckets 
