#!/bin/bash
#07.03.16
#benmafx

#Script to automize the secure loose ends process for viaf.

external=external_resources_tmp
raw=external_data.nt
sorted=external_data_sorted.nt


echo Create new folder for external resources
mkdir $external

echo Get male gender
wget --header "Accept: application/rdf+xml" http://www.wikidata.org/entity/Q6581097 -O $external/male.rdf

echo Get female gender
wget --header "Accept: application/rdf+xml" http://www.wikidata.org/entity/Q6581072 -O $external/female.rdf

echo Import
reshaperdf ntriplify $external external_data.nt

echo Remove temporary directory
rm -rf $external

echo Sort
reshaperdf sort $raw $sorted

rm $raw


echo Done


