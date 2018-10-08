#!/bin/bash
#10.12.15
#bensmafx

#Takes the link file and extracts the enrichment from dbpedia

source ./../paths/load_path_variables.sh

# Log start time
echo -n "Start post-processing VIAF: " >> "$LINKED_LOGGING/process.log"
date >> "$LINKED_LOGGING/process.log"

echo "Get enrichment"
reshaperdf getenrichment "$LINKED_TMP_DATA_FOLDER/viaf_link_file.nt" "$LINKED_TMP_DATA_FOLDER/viaf_persons_for_enrichment.nt" \
            "$LINKED_TMP_DATA_FOLDER/viaf_enrichment.nt" \
            &> "$LINKED_LOGGING/viaf_links_enrichment.log"

echo "Get loose ends from gender infos"
reshaperdf securelooseends "$LINKED_TMP_DATA_FOLDER/viaf_enrichment.nt" "$LINKED_TMP_DATA_FOLDER/external_data_sorted.nt" "$LINKED_TMP_DATA_FOLDER/viaf_ends.nt" \
            http://schema.org/gender http://linked.swissbib.ch/vocab/schemaGenderAsLiteral

# Log end time
echo -n "Finished post-processing VIAF: " >> "$LINKED_LOGGING/process.log"
date >> "$LINKED_LOGGING/process.log"

echo "Finished post-processing VIAF"
exit 0