#!/bin/bash
#10.12.15
#bensmafx


#Script to process DBPedia data for linking

#echo Delaying start by 5h
#sleep 18000


# Do not remove *.nt, external source is still needed
rm *.log
rm -rf viaf_blocks viaf_gnd_blocks

# Log start time
echo -n "Start: " >> times.log
date >> times.log


source ../load_sources.sh
status=0


# Import
echo Viaf data is present in one large N-Triples file, so no import necessary.


echo Filtering unwanted statements.
reshaperdf filter whitelist $viaf_data_dir/viaf-20160906-clusters-rdf.nt filter_4_compression.txt viaf_smaller.nt &>/dev/null
status=$?
if [ $status -eq 0 ]; then
#  rm $viaf_data_dir/viaf-20160712-clusters-rdf.nt
  echo Filtering unwanted statements ok.
else
  echo Error during filtering unwanted statements. Exiting. 1>&2
  exit $status
fi  

echo Sort
reshaperdf sort viaf_smaller.nt viaf_sorted.nt &>sort.log
status=$?
if [ $status -eq 0 ]; then
  echo Sorting ok.
#  rm viaf_smaller.nt
else
  echo Error during sorting. Exiting. 1>&2
  exit $status
fi 



echo Remove duplicate statements
reshaperdf removeduplicates viaf_sorted.nt viaf_sorted_wo_dup.nt &>remdup.log
status=$?
if [ $status -eq 0 ]; then
  echo Removing duplicate statements ok.
  rm viaf_sorted.nt
else
  echo Error during removal of duplicate statements. Exiting. 1>&2
  exit $status
fi 


echo Extract Persons
reshaperdf extractresources viaf_sorted_wo_dup.nt viaf_persons_all.nt http://www.w3.org/1999/02/22-rdf-syntax-ns#type http://schema.org/Person 0 -1 &>extract_persons.log
status=$?
if [ $status -eq 0 ]; then
  echo Extract persons ok.
else
  echo Error during extraction of persons. Exiting. 1>&2
  exit $status
fi 


echo Filter persons 4 linking
reshaperdf filter whitelist viaf_persons_all.nt filter_4_linking.txt viaf_persons_4_linking.nt &>filter2.log
status=$?
if [ $status -eq 0 ]; then
  echo Filtering persons 4 linking ok.
else
  echo Error during filtering of persons for linking. Exiting. 1>&2
  exit $status
fi 


echo Filter persons 4 enriching
reshaperdf filter whitelist viaf_persons_all.nt filter_4_enrichment.txt viaf_persons_4_enrichment.nt &>filter3.log
status=$?
if [ $status -eq 0 ]; then
  echo Filtering of persons 4 enrichment ok.
  rm viaf_persons_all.nt
else
  echo Error during filtering of persons 4 enrichtment. Exiting. 1>&2
  exit $status
fi


echo Block persons by family name
mkdir viaf_blocks
reshaperdf block viaf_persons_4_linking.nt viaf_blocks http://schema.org/familyName 0 1 &>block_persons_family_name.log
status=$?
if [ $status -eq 0 ]; then
  echo Blocking persons by family name ok.
else
  echo Error during blocking persons by family name. Exiting. 1>&2
  exit $status
fi


echo Block persons by gnd identifier
mkdir viaf_gnd_blocks
reshaperdf block viaf_persons_4_linking.nt viaf_gnd_blocks http://schema.org/sameAs 21 3 &>block_persons_gnd.log
status=$?
if [ $status -eq 0 ]; then
  echo Blocking persons by gnd identifier ok.
#  rm viaf_persons_4_linking.nt
else
  echo Error during blocking persons by gnd identifier. Exiting. 1>&2
  exit $status
fi



# Log end time
echo -n "End: " >> times.log
date >> times.log


echo done

