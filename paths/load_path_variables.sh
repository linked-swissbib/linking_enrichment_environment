#!/usr/bin/env bash

# saves various paths in variables. Call with 'source' at beginning of script to make them available.

if [ `whoami` == jonas ]; then
	echo "Load path variables for dev env."
	BASE_PATH='/home/jonas/linked/data'
elif [ `whoami` == swissbib ]; then
	echo "Load paths for prepare_swissbib data user!"
	BASE_PATH='/swissbib_index/data'
else
	>&2 echo "Unknown user name! Change user or expand script."
fi

export LINKED_SWISSBIB_SOURCE_DATA_FOLDER="$BASE_PATH/enrichedLineInput"
export LINKED_TARGET_DATA_FOLDER="$BASE_PATH/enrichedLineOutput"
export LINKED_TMP_DATA_FOLDER="$LINKED_TARGET_DATA_FOLDER/tmp"
export LINKED_DBPEDIA_DATA_FOLDER="$LINKED_TARGET_DATA_FOLDER/dbpedia"
export LINKED_VIAF_DATA_FOLDER="$LINKED_TARGET_DATA_FOLDER/viaf"
export LINKED_LOGGING="$LINKED_TARGET_DATA_FOLDER/logs"
export LINKED_WIKI_DATA_FOLDER="$LINKED_TARGET_DATA_FOLDER/wikidata"
