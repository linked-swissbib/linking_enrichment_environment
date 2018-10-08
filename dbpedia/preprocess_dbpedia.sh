#!/bin/bash
#10.12.15
#bensmafx

#Script to process DBpedia data for linking


source ../paths/load_path_variables.sh

CONFIG_DIR='config'

STATUS=0

rm -rf "$LINKED_TMP_DATA_FOLDER/dbpedia_blocks" "$LINKED_TMP_DATA_FOLDER/dbpedia_gnd_blocks"


# Log start time
echo -n "Start pre-processing of DBpedia data: " >> "$LINKED_LOGGING/process"
date >> "$LINKED_LOGGING/process"

echo "Start preprocessing of DBpedia"

echo "Importing data"
reshaperdf ntriplify "$LINKED_DBPEDIA_DATA_FOLDER" "$LINKED_TMP_DATA_FOLDER/dbpedia.nt" &> "$LINKED_LOGGING/dbpedia_import.log"

STATUS=$?

if [ "$STATUS" -eq 0 ]; then
  echo "Import ok."
else
  echo "Error during import. Exiting." 1>&2
  exit "$STATUS"
fi


echo "Remove unused statements"

reshaperdf filter whitelist "$LINKED_TMP_DATA_FOLDER/dbpedia.nt" "$CONFIG_DIR/filter_for_compression.txt" \
            "$LINKED_TMP_DATA_FOLDER/dbpedia_smaller.nt" &> /dev/null

STATUS=$?

if [ "$STATUS" -eq 0 ]; then
  echo "Removal of unused statements ok."
else
  echo "Error during removal of unused statements. Exiting." 1>&2
  exit "$STATUS"
fi


echo "Sort"
reshaperdf sort "$LINKED_TMP_DATA_FOLDER/dbpedia_smaller.nt" "$LINKED_TMP_DATA_FOLDER/dbpedia_sorted.nt" \
                &> "$LINKED_LOGGING/dbpedia_sort.log"

STATUS=$?

if [ "$STATUS" -eq 0 ]; then
  echo "Sorting ok."
else
  echo "Error during sorting. Exiting." 1>&2
  exit "$STATUS"
fi

echo "Remove duplicate statements"

reshaperdf removeduplicates "$LINKED_TMP_DATA_FOLDER/dbpedia_sorted.nt" "$LINKED_TMP_DATA_FOLDER/dbpedia_sorted_wo_dup.nt" \
            &> "$LINKED_LOGGING/dbpedia_remove_duplicates.log"

STATUS=$?

if [ "$STATUS" -eq 0 ]; then
  echo "Removal of duplicate statements ok."
else
  echo "Error during removal of duplicate statements. Exiting." 1>&2
  exit "$STATUS"
fi

echo "Rename surname property"

reshaperdf renameproperty "$LINKED_TMP_DATA_FOLDER/dbpedia_sorted_wo_dup.nt" "$LINKED_TMP_DATA_FOLDER/dbpedia_sorted_wo_dup_renamed.nt" \
        http://xmlns.com/foaf/0.1/surname http://xmlns.com/foaf/0.1/familyName \
        &> "$LINKED_LOGGING/dbpedia_rename_surname.log"

STATUS=$?

if [ "$STATUS" -eq 0 ]; then
  echo "Renaming of surname property ok."
else
  echo "Error during renaming of surname property. Exiting." 1>&2
  exit "$STATUS"
fi


echo "Extract Persons"
reshaperdf extractresources "$LINKED_TMP_DATA_FOLDER/dbpedia_sorted_wo_dup_renamed.nt" "$LINKED_TMP_DATA_FOLDER/dbpedia_persons_all.nt" \
            http://www.w3.org/1999/02/22-rdf-syntax-ns#type http://xmlns.com/foaf/0.1/Person 0 -1 \
            &> "$LINKED_LOGGING/dbpedia_extract_persons.log"
STATUS=$?

if [ "$STATUS" -eq 0 ]; then
  echo "Extraction of persons ok."
else
  echo "Error during extraction of persons. Exiting." 1>&2
  exit "$STATUS"
fi


echo "Filter persons for linking"
reshaperdf filter whitelist "$LINKED_TMP_DATA_FOLDER/dbpedia_persons_all.nt" "$CONFIG_DIR/filter_for_linking.txt" \
                "$LINKED_TMP_DATA_FOLDER/dbpedia_persons_for_linking.nt" &>  "$LINKED_LOGGING/dbpedia_filter_link.log"
STATUS=$?
if [ "$STATUS" -eq 0 ]; then
  echo "Filtering of persons for linking ok."
else 
  echo "Error during filtering of persons for linking. Exiting." 1>&2
  exit "$STATUS"
fi


echo "Filter persons for enriching"

reshaperdf filter whitelist "$LINKED_TMP_DATA_FOLDER/dbpedia_persons_all.nt" "$CONFIG_DIR/filter_for_enrichment.txt" \
        "$LINKED_TMP_DATA_FOLDER/dbpedia_persons_for_enrichment.nt" &> "$LINKED_LOGGING/dbpedia_filter_enrich.log"

STATUS=$?

if [ "$STATUS" -eq 0 ]; then
  echo "Filtering persons for enrichment ok."
else
  echo "Error during filtering of persons. Exiting." 1>&2
  exit "$STATUS"
fi


echo "Block persons"

mkdir "$LINKED_TMP_DATA_FOLDER/dbpedia_blocks"

reshaperdf block "$LINKED_TMP_DATA_FOLDER/dbpedia_persons_for_linking.nt" "$LINKED_TMP_DATA_FOLDER/dbpedia_blocks" \
                  http://xmlns.com/foaf/0.1/familyName 0 1 &> "$LINKED_LOGGING/viaf_block_persons.log"

STATUS=$?

if [ "$STATUS" -eq 0 ]; then
  echo "Blocking persons ok."
else
  echo "Error during blocking of persons. Exiting." 1>&2
  exit "$STATUS"
fi

# Log end time
echo -n "Finished dbpedia pre-processing: " >> "$LINKED_LOGGING/process"
date >> "$LINKED_LOGGING/process"


echo "Finished dbpedia pre-processing"
exit 0
