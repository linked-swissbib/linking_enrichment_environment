#!/bin/bash
#10.12.15
#bensmafx

#Script to process swissbib data for linking


source ../load_sources.sh
status=0

rm *.nt *.log
rm -rf swissbib_blocks swissbib_gnd_blocks


# Log start time
echo -n "Start: " >> time.log
date >> time.log


echo Importing data
context_dir=contexts
context_prefix=https://resources.swissbib.ch
reshaperdf ntriplify $swissbib_data_dir swissbib.nt $context_prefix/document/context.jsonld $context_dir/document/context.jsonld $context_prefix/item/context.jsonld $context_dir/item/context.jsonld $context_prefix/organisation/context.jsonld $context_dir/organisation/context.jsonld $context_prefix/person/context.jsonld $context_dir/person/context.jsonld $context_prefix/resource/context.jsonld $context_dir/resource/context.jsonld $context_prefix/work/context.jsonld $context_dir/work/context.jsonld &>import.log
status=$?
if [ $status -eq 0 ]; then
  echo Importing ok. 
else
  echo Error during import. Exiting. 1>&2
  exit $status
fi


echo Filtering unwanted statements
reshaperdf filter whitelist swissbib.nt filter_4_compression.txt swissbib_smaller.nt 2>err.log &>/dev/null
status=$?
if [ $status -eq 0 ]; then
  echo Filtering unwanted statements ok. 
#  rm swissbib.nt
else
  echo Error during filtering of unwanted statements. Exiting. 1>&2
  exit $status
fi


echo Sort
reshaperdf sort swissbib_smaller.nt swissbib_sorted.nt &>sort.log
status=$?
if [ $status -eq 0 ]; then
   echo Sorting ok.
#  rm swissbib_smaller.nt
else
  echo Error during sorting. Exiting. 1>&2
  exit $status
fi


echo Remove duplicate statements
reshaperdf removeduplicates swissbib_sorted.nt swissbib_sorted_wo_dup.nt &>remdup.log
status=$?
if [ $status -eq 0 ]; then
  echo Remove duplicate statements ok.
#  rm swissbib_sorted.nt
else
  echo Error during removal of duplicate statements. Exiting. 1>&2
  exit $status
fi



echo Extract persons
reshaperdf extractresources swissbib_sorted_wo_dup.nt swissbib_persons_all.nt http://www.w3.org/1999/02/22-rdf-syntax-ns#type http://xmlns.com/foaf/0.1/Person 0 -1 &>extract_persons.log
status=$?
if [ $status -eq 0 ]; then
  echo Extract persons ok.
#  rm swissbib_sorted_wo_dup.nt
else
  echo Error during extraction of persons. Exiting. 1>&2
  exit $status
fi


echo Extract Organizations
reshaperdf extractresources swissbib_sorted_wo_dup.nt swissbib_organizations_all.nt http://www.w3.org/1999/02/22-rdf-syntax-ns#type http://xmlns.com/foaf/0.1/Organization 0 -1 &>extract_organizations.log
status=$?
if [ $status -eq 0 ]; then
  echo Extracting organizations ok.
else
  echo Error during extraction of organizations. Exiting. 1>&2
  exit $status
fi



echo Filter persons 4 linking
reshaperdf filter whitelist swissbib_persons_all.nt filter_4_linking.txt swissbib_persons_4_linking.nt &>filter2.log
status=$?
if [ $status -eq 0 ]; then
  echo Filtering persons for linking ok.
else
  echo Error during filtering of persons for linking. Exiting. 1>&2
  exit $status
fi



echo Block persons by last name
mkdir -p swissbib_blocks
reshaperdf block swissbib_persons_4_linking.nt swissbib_blocks http://xmlns.com/foaf/0.1/lastName 0 1 &>block_last_name_persons.log
status=$?
if [ $status -eq 0 ]; then
  echo Blocking persons by last name ok.
#  rm swissbib_persons_4_linking.nt
else
  echo Error during blocking of persons by last name. Exiting. 1>&2
  exit $status
fi


echo Block persons by gnd identifier
mkdir -p swissbib_gnd_blocks
reshaperdf block swissbib_persons_4_linking.nt swissbib_gnd_blocks http://www.w3.org/2002/07/owl#sameAs 21 3 &>block_gnd_persons.log
status=$?
if [ $status -eq 0 ]; then
  echo Blocking persons by gnd identifier ok.
#  rm swissbib_persons_4_linking.nt
else
  echo Error during blocking of persons by gnd identifier. Exiting. 1>&2
  exit $status
fi


exit $status




# Log end time
echo -n "End: " >> time.log
date >> time.log



echo done
