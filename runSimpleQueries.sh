#!/bin/bash 

# Author: Sufyaan Kazi
# Date: April 2018
# Purpose: Run Simple Queries with Big Query

runBQCommand() {
 bq $@
 sleep 2
}

cleanup() {
  bq rm -rf babynames
  if [ -d babynames ]; then
    rm -rf babynames
  fi
}

# gcloud config set project $1

# Query Sample data
runBQCommand show publicdata:samples.shakespeare
runBQCommand query "SELECT word, corpus, COUNT(word) FROM publicdata:samples.shakespeare WHERE word CONTAINS 'raisin' GROUP BY word, corpus"
runBQCommand ls publicdata:
bq ls

# Load in external data
cleanup

echo ""
echo "About to load babynames public data into Big Query"
mkdir babynames
cd babynames
wget http://www.ssa.gov/OACT/babynames/names.zip --no-check-certificate
unzip names.zip

runBQCommand mk babynames
bq load babynames.names2016 yob2016.txt name:string,gender:string,count:integer
runBQCommand show babynames.names2016
runBQCommand query "SELECT name,count FROM babynames.names2016 WHERE gender = 'F' ORDER BY count DESC LIMIT 5"

cd ..
cleanup
