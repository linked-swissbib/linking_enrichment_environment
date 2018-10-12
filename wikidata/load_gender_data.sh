#!/bin/bash
#07.03.16
#benmafx

#This script loads data from the wikidata set on gender.

source ./../paths/load_path_variables.sh

rm -r "$LINKED_TMP_DATA_FOLDER/external_resources"

EXTERNAL_RESOURCES_FOLDER="$LINKED_TMP_DATA_FOLDER/external_resources"

echo "Create new folder for external resources"
mkdir "$EXTERNAL_RESOURCES_FOLDER"

echo "Get male gender"
wget --header "Accept: application/rdf+xml" http://www.wikidata.org/entity/Q6581097 -O "$EXTERNAL_RESOURCES_FOLDER/male.rdf"

echo "Get female gender"
wget --header "Accept: application/rdf+xml" http://www.wikidata.org/entity/Q6581072 -O "$EXTERNAL_RESOURCES_FOLDER/female.rdf"

echo "Make ntriples form the data."
reshaperdf ntriplify "$EXTERNAL_RESOURCES_FOLDER" "$EXTERNAL_RESOURCES_FOLDER/gender_data.nt"

echo "Sort external ntriples data."
reshaperdf sort "$EXTERNAL_RESOURCES_FOLDER/gender_data.nt" "$LINKED_WIKI_DATA_FOLDER/gender_data_sorted.nt"

echo "Finished preparing gender data."
