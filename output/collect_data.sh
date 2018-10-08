#!/bin/bash
#bensmafx
#15.8.16

# Script collects all data for final output

source ././../paths/load_path_variables.sh

# Log start time
echo -n "Start output data collection: " >> "$LINKED_LOGGING/process.log"
date >> "$LINKED_LOGGING/process.log"


cat swissbib/swissbib_persons_all.nt swissbib/swissbib_organizations_all.nt \
    "$LINKED_TMP_DATA_FOLDER/dbpedia_link_file.nt" "$LINKED_TMP_DATA_FOLDER/dbpedia_enrichment.nt" \
    "$LINKED_TMP_DATA_FOLDER/dbpedia_ends.nt" \
    "$LINKED_TMP_DATA_FOLDER/viaf_enrichment.nt" "$LINKED_TMP_DATA_FOLDER/viaf_ends.nt" \
    "$LINKED_TMP_DATA_FOLDER/viaf_link_file.nt" \
    > "$LINKED_TMP_DATA_FOLDER/swissbib_out.nt"
reshaperdf sort "$LINKED_TMP_DATA_FOLDER/swissbib_out.nt" "$LINKED_TMP_DATA_FOLDER/swissbib_out_sorted.nt"

rm "$LINKED_TMP_DATA_FOLDER/swissbib_out.nt"

# Log end time
echo -n "End output data collection: " >> "$LINKED_LOGGING/process.log"
date >> "$LINKED_LOGGING/process.log"

echo "Finished output data collection"
exit 0
