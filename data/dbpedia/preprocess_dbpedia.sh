#!/bin/bash
#10.12.15
#bensmafx

#Script to process DBpedia data for linking


source ../load_sources.sh
status=0

rm *.nt *.log
rm -rf dbpedia_blocks dbpedia_gnd_blocks


# Log start time
echo -n "Start: " >> times.log
date >> times.log

echo Start preprocessing of DBpedia


echo Importing data
reshaperdf ntriplify $dbp_data_dir dbpedia.nt &>import.log
status=$?
if [ $status -eq 0 ]; then
  echo Import ok.
  rm $dbp_data_dir/*.nt
else
  echo Error during import. Exiting. 1>&2
  exit $status
fi


echo Remove unused statements
reshaperdf filter whitelist dbpedia.nt filter_4_compression.txt dbpedia_smaller.nt &> /dev/null
status=$?
if [ $status -eq 0 ]; then
  echo Removal of unused statements ok.
  rm dbpedia.nt
else
  echo Error during removal of unused statements. Exiting. 1>&2
  exit $status
fi


echo Sort
reshaperdf sort dbpedia_smaller.nt dbpedia_sorted.nt &>sort.log
status=$?
if [ $status -eq 0 ]; then
  echo Sorting ok.
  rm dbpedia_smaller.nt
else
  echo Error during sorting. Exiting. 1>&2
  exit $status
fi


echo Remove duplicate statements
reshaperdf removeduplicates dbpedia_sorted.nt dbpedia_sorted_wo_dup.nt &>remdup.log
status=$?
if [ $status -eq 0 ]; then
  echo Removal of duplicate statements ok.
  rm dbpedia_sorted.nt
else
  echo Error during removal of duplicate statements. Exiting. 1>&2
  exit $status
fi


echo Rename surname property
reshaperdf renameproperty dbpedia_sorted_wo_dup.nt dbpedia_sorted_wo_dup_renamed.nt http://xmlns.com/foaf/0.1/surname http://xmlns.com/foaf/0.1/familyName &>rename.log
status=$?
if [ $status -eq 0 ]; then
  echo Renaming of surname property ok.
  rm dbpedia_sorted_wo_dup.nt
else
  echo Error during renaming of surname property. Exiting. 1>&2
  exit $status
fi


echo Extract Persons
reshaperdf extractresources dbpedia_sorted_wo_dup_renamed.nt dbpedia_persons_all.nt http://www.w3.org/1999/02/22-rdf-syntax-ns#type http://xmlns.com/foaf/0.1/Person 0 -1 &>extract_persons.log
status=$?
if [ $status -eq 0 ]; then
  echo Extraction of persons ok.
else
  echo Error during extraction of persons. Exiting. 1>&2
  exit $status
fi


echo Filter persons 4 linking
reshaperdf filter whitelist dbpedia_persons_all.nt filter_4_linking.txt dbpedia_persons_4_linking.nt &>filter2.log
status=$?
if [ $status -eq 0 ]; then
  echo Filtering of persons 4 linking ok.
else 
  echo Error during filtering of persons 4 linking. Exiting. 1>&2
  exit $status
fi


echo Filter persons 4 enriching
reshaperdf filter whitelist dbpedia_persons_all.nt filter_4_enrichment.txt dbpedia_persons_4_enrichment.nt &>filter3.log
status=$?
if [ $status -eq 0 ]; then
  echo Filtering persons 4 enrichment ok.
  rm dbpedia_persons_all.nt
else
  echo Error during filtering of persons. Exiting. 1>&2
  exit $status
fi


echo Block persons
mkdir dbpedia_blocks
reshaperdf block dbpedia_persons_4_linking.nt dbpedia_blocks http://xmlns.com/foaf/0.1/familyName 0 1 &>block_persons.log
status=$?
if [ $status -eq 0 ]; then
  echo Blocking persons ok.
  rm dbpedia_persons_4_linking.nt
else
  echo Error during blocking of persons. Exiting. 1>&2
  exit $status
fi


# Log end time
echo -n "End: " >> times.log
date >> times.log


echo Done

