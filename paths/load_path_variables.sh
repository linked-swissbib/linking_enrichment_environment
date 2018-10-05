#!/usr/bin/env bash

# saves various paths in variables. Call with 'source' at beginning of script to make them available.

if [ `whoami` == jonas ]; then
	echo "Load path variables for dev env."

	export LINKED_SWISSBIB_SOURCE_DATA_FOLDER='/home/jonas/linked/data/enrichedLineInput'
    export LINKED_TARGET_DATA_FOLDER='/home/jonas/linked/data/enrichedLineOuput'
    export LINKED_TMP_DATA_FOLDER="$LINKED_TARGET_DATA_FOLDER/tmp"
    export LINKED_DBPEDIA_DATA_FOLDER="$LINKED_TARGET_DATA_FOLDER/dbpedia"
    export LINKED_VIAF_DATA_FOLDER="$LINKED_TARGET_DATA_FOLDER/viaf"
    export LINKED_LOGGING="$LINKED_TARGET_DATA_FOLDER/logs"
	export dbp_data_dir=$HOME/Data/DBPedia
	export viaf_data_dir=$HOME/Data/VIAF
elif [ `whoami` == swissbib ]; then
	echo "Load paths for prepare_swissbib_data user!"
	export LINKED_SWISSBIB_SOURCE_DATA_FOLDER='/swissbib_index/data/enrichedLineInput'
    export LINKED_TARGET_DATA_FOLDER='/swissbib_index/data/enrichedLineOuput'
    export LINKED_TMP_DATA_FOLDER="$LINKED_TARGET_DATA_FOLDER/tmp"
    export LINKED_DBPEDIA_DATA_FOLDER="$LINKED_TARGET_DATA_FOLDER/dbpedia"
    export LINKED_VIAF_DATA_FOLDER="$LINKED_TARGET_DATA_FOLDER/viaf"
    export LINKED_LOGGING="$LINKED_TARGET_DATA_FOLDER/logs"
	export dbp_data_dir=/swissbib_index/linking/data/dbpedia/raw
	export viaf_data_dir=/swissbib_index/linking/data/viaf/raw
else
	>&2 echo "Unknown user name! Change user or expand script."
fi
