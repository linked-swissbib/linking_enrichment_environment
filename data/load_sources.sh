#!/bin/bash
#bensmafx
#4.8.16

# Saves the places of the various data sources in variables; to be used in other scripts

if [ `whoami` == bensmafx ]; then
	echo Using settings for development environment.
	export swissbib_data_dir=$HOME/Data/swissbib
	export dbp_data_dir=$HOME/Data/DBPedia
	export viaf_data_dir=$HOME/Data/VIAF
elif [ `whoami` == swissbib ]; then
	echo Using settings for productive environment
	export swissbib_data_dir=/swissbib_index/lsbPlatform/data/enrichedLineInput
	export dbp_data_dir=/swissbib_index/linking/data/dbpedia/raw
	export viaf_data_dir=/swissbib_index/linking/data/viaf/raw
else
	>&2 echo Unrecognized user name.
fi


