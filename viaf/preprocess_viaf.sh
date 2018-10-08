#!/bin/bash
#10.12.15
#bensmafx


#Script to process DBPedia data for linking

#echo Delaying start by 5h
#sleep 18000

source ./../paths/load_path_variables.sh

# Do not remove *.nt, external source is still needed
rm -rf "$LINKED_TMP_DATA_FOLDER/viaf_blocks" "$LINKED_TMP_DATA_FOLDER/viaf_gnd_blocks"

echo -n "Start pre-process VIAF data: " >> "$LINKED_LOGGING/process.log"
date >> "$LINKED_LOGGING/process.log"

STATUS=0
CONFIG_DIR='configs'

# Import
echo Viaf data is present in one large N-Triples file, so no import necessary.


# TODO: Which ones are unwanted and why?
echo "Filtering unwanted statements."
reshaperdf filter whitelist "$LINKED_VIAF_DATA_FOLDER/viaf-20160906-clusters-rdf.nt" "$CONFIG_DIR/filter_for_compression.txt" \
            "$LINKED_TMP_DATA_FOLDER/viaf_removed_unwanted.nt" &> /dev/null

STATUS=$?
if [ "$STATUS" -eq 0 ]; then
  echo "Filtering unwanted statements ok."
else
  echo "Error during filtering unwanted statements. Exiting." 1>&2
  exit "$STATUS"
fi  

echo "Sort viaf statements"
reshaperdf sort "$LINKED_TMP_DATA_FOLDER/viaf_removed_unwanted.nt" "$LINKED_TMP_DATA_FOLDER/viaf_sorted.nt" &> "$LINKED_LOGGING/viaf_sorting.log"

STATUS=$?

if [ "$STATUS" -eq 0 ]; then
  echo "Sorting ok."
else
  echo "Error during sorting. Exiting." 1>&2
  exit "$STATUS"
fi 

echo "Remove duplicate statements"
reshaperdf removeduplicates "$LINKED_VIAF_DATA_FOLDER/viaf_sorted.nt" "$LINKED_TMP_DATA_FOLDER/viaf_sorted_wo_dup.nt" &> "$LINKED_LOGGING/viaf_remove_duplicates.log"

STATUS=$?

if [ "$STATUS" -eq 0 ]; then
  echo "Removing duplicate statements ok."
else
  echo "Error during removal of duplicate statements. Exiting." 1>&2
  exit "$STATUS"
fi 


echo "Extract Persons"
reshaperdf extractresources "$LINKED_TMP_DATA_FOLDER/viaf_sorted_wo_dup.nt" "$LINKED_TMP_DATA_FOLDER/viaf_persons_all.nt" \
            http://www.w3.org/1999/02/22-rdf-syntax-ns#type http://schema.org/Person 0 -1 \
            &> "$LINKED_LOGGING/viaf_extract_persons.log"

STATUS=$?

if [ "$STATUS" -eq 0 ]; then
  echo "Extract persons ok."
else
  echo "Error during extraction of persons. Exiting." 1>&2
  exit "$STATUS"
fi 


echo "Filter persons for linking"
reshaperdf filter whitelist "$LINKED_TMP_DATA_FOLDER/viaf_persons_all.nt" "$CONFIG_DIR/filter_for_linking.txt" \
              "$LINKED_TMP_DATA_FOLDER/viaf_persons_for_linking.nt" &> "$LINKED_LOGGING/viaf_filter_persons.log"

STATUS=$?

if [ "$STATUS" -eq 0 ]; then
  echo "Filtering persons for linking ok."
else
  echo "Error during filtering of persons for linking. Exiting." 1>&2
  exit "$STATUS"
fi 


echo "Filter persons for enriching"
reshaperdf filter whitelist "$LINKED_TMP_DATA_FOLDER/viaf_persons_all.nt" "$CONFIG_DIR/filter_for_enrichment.txt" \
                            "$LINKED_TMP_DATA_FOLDER/viaf_persons_for_enrichment.nt" \
                            &> "$LINKED_LOGGING/viaf_filter_enrich.log"

STATUS=$?

if [ "$STATUS" -eq 0 ]; then
  echo "Filtering of persons for enrichment ok."
else
  echo "Error during filtering of persons for enrichtment. Exiting." 1>&2
  exit "$STATUS"
fi


echo "Block persons by family name"
mkdir "$LINKED_TMP_DATA_FOLDER/viaf_blocks"

reshaperdf block "$LINKED_TMP_DATA_FOLDER/viaf_persons_for_linking.nt" "$LINKED_TMP_DATA_FOLDER/viaf_blocks" \
                    http://schema.org/familyName 0 1 &> "$LINKED_LOGGING/viaf_block_persons_family_name.log"

STATUS=$?

if [ "$STATUS" -eq 0 ]; then
  echo "Blocking persons by family name ok."
else
  echo "Error during blocking persons by family name. Exiting." 1>&2
  exit "$STATUS"
fi


echo "Block persons by gnd identifier"
mkdir "$LINKED_TMP_DATA_FOLDER/viaf_gnd_blocks"

reshaperdf block "$LINKED_TMP_DATA_FOLDER/viaf_persons_for_linking.nt" "$LINKED_TMP_DATA_FOLDER/viaf_gnd_blocks" \
                    http://schema.org/sameAs 21 3 &> "$LINKED_LOGGING/viaf_block_persons_gnd.log"

STATUS=$?

if [ "$STATUS" -eq 0 ]; then
  echo "Blocking persons by gnd identifier ok."
else
  echo "Error during blocking persons by gnd identifier. Exiting." 1>&2
  exit "$STATUS"
fi

# Log end time
echo -n "Finished pre-process VIAF data: " >> "$LINKED_LOGGING/process.log"
date >> "$LINKED_LOGGING/process.log"

echo "Finished pre-process VIAF data"
exit 0
