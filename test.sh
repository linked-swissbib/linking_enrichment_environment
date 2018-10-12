#!/usr/bin/env bash


source ./paths/load_path_variables.sh
CONFIG_DIR="swissbib/config"



# Get DBpedia enrichment
cd dbpedia

./postprocess_dbpedia.sh

STATUS=$?

if [ "$STATUS" -eq 0 ]; then
  echo "Enriching with DBpedia ok."
else
  echo "Error during enrichment with DBpedia. Exiting." 1>&2
  exit "$STATUS"
fi
