#!/bin/bash
#10.12.15
#bensmafx

#Script to process swissbib data for linking


source ../paths/load_path_variables.sh
RETURN_STATUS=0

CONFIG_DIR='config'

rm -rf swissbib_blocks swissbib_gnd_blocks


# Log start time
echo -n "Start swissbib process: " >> "$LINKED_LOGGING/process.log"
date >> "$LINKED_LOGGING/process.log"


echo "Import swissbib data"

SWISSBIB_CONTEXT_DIR="$CONFIG_DIR/contexts"
SWISSBIB_CONTEXT_PREFIX=https://resources.swissbib.ch

# What does this do?
reshaperdf ntriplify "$LINKED_SWISSBIB_SOURCE_DATA_FOLDER" "$LINKED_TMP_DATA_FOLDER/swissbib.nt" \
    "$SWISSBIB_CONTEXT_PREFIX/document/context.jsonld" "$SWISSBIB_CONTEXT_DIR/document/context.jsonld" \
    "$SWISSBIB_CONTEXT_PREFIX/item/context.jsonld" "$SWISSBIB_CONTEXT_DIR/item/context.jsonld" \
    "$SWISSBIB_CONTEXT_PREFIX/organisation/context.jsonld" "$SWISSBIB_CONTEXT_DIR/organisation/context.jsonld" \
    "$SWISSBIB_CONTEXT_PREFIX/person/context.jsonld" "$SWISSBIB_CONTEXT_DIR/person/context.jsonld" \
    "$SWISSBIB_CONTEXT_PREFIX/resource/context.jsonld" "$SWISSBIB_CONTEXT_DIR/resource/context.jsonld" \
    "$SWISSBIB_CONTEXT_PREFIX/work/context.jsonld" "$SWISSBIB_CONTEXT_DIR/work/context.jsonld" \
    &> "$LINKED_LOGGING/sb_import.log"

RETURN_STATUS=$?

if [ "$RETURN_STATUS" -eq 0 ]; then
  echo "Import was successful!"
else
  echo "Could not import data. Exiting." 1>&2
  exit "$RETURN_STATUS"
fi

# What does this do?
# Currently nothing as the swissbib.nt only contains things we want to keep. The smaller file is not smaller at all.
echo "Filtering unwanted statements"

reshaperdf filter whitelist "$LINKED_TMP_DATA_FOLDER/swissbib.nt" "$CONFIG_DIR/filter_for_compression.txt" \
                    "$LINKED_TMP_DATA_FOLDER/swissbib_smaller.nt" 2>"$LINKED_LOGGING/sb_filter_unwanted.log" &> /dev/null

RETURN_STATUS=$?

if [ "$RETURN_STATUS" -eq 0 ]; then
  echo "Filtering unwanted statements ok."
else
  echo "Error during filtering of unwanted statements. Exiting." 1>&2
  exit "$RETURN_STATUS"
fi


echo "Sort swissbib data triples."
reshaperdf sort "$LINKED_TMP_DATA_FOLDER/swissbib_smaller.nt" "$LINKED_TMP_DATA_FOLDER/swissbib_sorted.nt" &> "$LINKED_LOGGING/sb_sort.log"

RETURN_STATUS=$?
if [ "$RETURN_STATUS" -eq 0 ]; then
   echo "Sorting ok."
else
  echo "Error during sorting. Exiting." 1>&2
  exit "$RETURN_STATUS"
fi


# Warum hat es soviele duplicates im Swissbib Datenset?
echo "Remove duplicate statements"
reshaperdf removeduplicates "$LINKED_TMP_DATA_FOLDER/swissbib_sorted.nt" "$LINKED_TMP_DATA_FOLDER/swissbib_sorted_wo_dup.nt" &> "$LINKED_LOGGING/sb_remove_duplicates.log"

RETURN_STATUS=$?

if [ "$RETURN_STATUS" -eq 0 ]; then
  echo "Remove duplicate statements ok."
else
  echo "Error during removal of duplicate statements. Exiting." 1>&2
  exit "$RETURN_STATUS"
fi



echo "Extract persons"
reshaperdf extractresources "$LINKED_TMP_DATA_FOLDER/swissbib_sorted_wo_dup.nt" "$LINKED_TMP_DATA_FOLDER/swissbib_persons_all.nt" \
            http://www.w3.org/1999/02/22-rdf-syntax-ns#type http://xmlns.com/foaf/0.1/Person 0 -1 &> "$LINKED_LOGGING/sb_extract_persons.log"

RETURN_STATUS=$?

if [ "$RETURN_STATUS" -eq 0 ]; then
  echo "Extract persons ok."
else
  echo "Error during extraction of persons. Exiting." 1>&2
  exit "$RETURN_STATUS"
fi


echo "Extract Organizations"
reshaperdf extractresources "$LINKED_TMP_DATA_FOLDER/swissbib_sorted_wo_dup.nt" "$LINKED_TMP_DATA_FOLDER/swissbib_organizations_all.nt" \
            http://www.w3.org/1999/02/22-rdf-syntax-ns#type http://xmlns.com/foaf/0.1/Organization 0 -1 &> "$LINKED_LOGGING/sb_extract_organizations.log"

RETURN_STATUS=$?

if [ "$RETURN_STATUS" -eq 0 ]; then
  echo "Extracting organizations ok."
else
  echo "Error during extraction of organizations. Exiting." 1>&2
  exit "$RETURN_STATUS"
fi



echo "Filter persons for linking"
reshaperdf filter whitelist "$LINKED_TMP_DATA_FOLDER/swissbib_persons_all.nt" "$CONFIG_DIR/filter_for_linking.txt" \
            "$LINKED_TMP_DATA_FOLDER/swissbib_persons_for_linking.nt" \
            &> "$LINKED_LOGGING/sb_filter_persons_for_linking.log"

RETURN_STATUS=$?

if [ "$RETURN_STATUS" -eq 0 ]; then
  echo "Filtering persons for linking ok."
else
  echo "Error during filtering of persons for linking. Exiting." 1>&2
  exit "$RETURN_STATUS"
fi



echo "Block persons by last name"
mkdir -p "$LINKED_TMP_DATA_FOLDER/swissbib_blocks"
reshaperdf block "$LINKED_TMP_DATA_FOLDER/swissbib_persons_for_linking.nt" "$LINKED_TMP_DATA_FOLDER/swissbib_blocks" http://xmlns.com/foaf/0.1/lastName 0 1 &> "$LINKED_LOGGING/sb_block_last_name_persons.log"

RETURN_STATUS=$?

if [ "$RETURN_STATUS" -eq 0 ]; then
  echo "Blocking persons by last name ok."
else
  echo "Error during blocking of persons by last name. Exiting." 1>&2
  exit "$RETURN_STATUS"
fi

echo "Block persons by gnd identifier"
mkdir -p "$LINKED_TMP_DATA_FOLDER/swissbib_gnd_blocks"
reshaperdf block "$LINKED_TMP_DATA_FOLDER/swissbib_persons_for_linking.nt" "$LINKED_TMP_DATA_FOLDER/swissbib_gnd_blocks" http://www.w3.org/2002/07/owl#sameAs 21 3 &> "$LINKED_LOGGING/sb_block_gnd_persons.log"

RETURN_STATUS=$?

if [ "$RETURN_STATUS" -eq 0 ]; then
  echo "Blocking persons by gnd identifier ok."
else
  echo "Error during blocking of persons by gnd identifier. Exiting." 1>&2
  exit "$RETURN_STATUS"
fi





# Log end time
echo -n "End swissbib process: " >> "$LINKED_LOGGING/process.log"
date >> "$LINKED_LOGGING/process.log"
echo "Done swissbib process"

exit "$RETURN_STATUS"
