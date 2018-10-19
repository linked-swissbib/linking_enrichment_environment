#!/bin/bash
#10.12.15
#bensmafx

#Script to process swissbib data for linking
# What to do?

IMPORT_SWISSBIB=0
FILTER_SWISSBIB=0
SORT_SWISSBIB=0
REMOVE_DUPLICATES_SWISSBIB=0
EXTRACT_PERSONS_SWISSBIB=0
EXTRACT_ORGANISATIONS_SWISSBIB=0
FILTER_PERSONS_FOR_LINKING_SWISSBIB=0
BLOCK_PERSONS_BY_LAST_NAME=0
BLOCK_PERSONS_BY_GND=0

source ../paths/load_path_variables.sh
RETURN_STATUS=0

CONFIG_DIR='config'

SWISSBIB_TMP_DATA_FOLDER="$LINKED_TMP_DATA_FOLDER/swissbib_preprocess"

if [ ! -d "$SWISSBIB_TMP_DATA_FOLDER" ] ; then
    mkdir "$SWISSBIB_TMP_DATA_FOLDER"
fi

# Log start time
echo -n "Start swissbib process: " >> "$LINKED_LOGGING/process.log"
date >> "$LINKED_LOGGING/process.log"

if [ $IMPORT_SWISSBIB -eq 1 ] ; then
    echo "Combining all the swissbib source data into a single large n-triple file."
    echo "Currently the swissbib data is present as json-ld in files."

    SWISSBIB_CONTEXT_DIR="$CONFIG_DIR/contexts"
    SWISSBIB_CONTEXT_PREFIX=https://resources.swissbib.ch

    reshaperdf ntriplify "$LINKED_SWISSBIB_SOURCE_DATA_FOLDER" "$SWISSBIB_TMP_DATA_FOLDER/swissbib.nt" \
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
fi

if [ $FILTER_SWISSBIB -eq 1 ] ; then
    # Currently nothing as the swissbib.nt only contains things we want to keep. The smaller file is not smaller at all.
    echo "Filter triples not used during this process using a whitelist."
    #
    reshaperdf filter whitelist "$SWISSBIB_TMP_DATA_FOLDER/swissbib.nt" "$CONFIG_DIR/filter_for_compression.txt" \
                        "$SWISSBIB_TMP_DATA_FOLDER/swissbib_filtered.nt" 2> "$LINKED_LOGGING/sb_filter_unwanted.log" &> /dev/null

    RETURN_STATUS=$?

    if [ "$RETURN_STATUS" -eq 0 ]; then
      echo "Filtering unwanted statements ok."
    else
      echo "Error during filtering of unwanted statements. Exiting." 1>&2
      exit "$RETURN_STATUS"
    fi

else
    # if no filter ist applied the file is simply copied.
    cp "$SWISSBIB_TMP_DATA_FOLDER/swissbib.nt" "$SWISSBIB_TMP_DATA_FOLDER/swissbib_filtered.nt"
fi


if [ $SORT_SWISSBIB -eq 1 ] ; then
    # this is necessary as ReShapeRDF expects a sorted file.
    echo "Sort swissbib data triples."
    reshaperdf sort "$SWISSBIB_TMP_DATA_FOLDER/swissbib_filtered.nt" "$SWISSBIB_TMP_DATA_FOLDER/swissbib_sorted.nt" \
                    &> "$LINKED_LOGGING/sb_sort.log"

    RETURN_STATUS=$?

    if [ "$RETURN_STATUS" -eq 0 ]; then
        echo "Sorting ok."
    else
        echo "Error during sorting. Exiting." 1>&2
        exit "$RETURN_STATUS"
    fi
fi

if [ $REMOVE_DUPLICATES_SWISSBIB -eq 1 ] ; then
    echo "Remove duplicate statements"
    reshaperdf removeduplicates "$SWISSBIB_TMP_DATA_FOLDER/swissbib_sorted.nt" "$SWISSBIB_TMP_DATA_FOLDER/swissbib_sorted_wo_dup.nt" &> "$LINKED_LOGGING/sb_remove_duplicates.log"

    RETURN_STATUS=$?

    if [ "$RETURN_STATUS" -eq 0 ]; then
      echo "Remove duplicate statements ok."
    else
      echo "Error during removal of duplicate statements. Exiting." 1>&2
      exit "$RETURN_STATUS"
    fi
fi

if [ $EXTRACT_PERSONS_SWISSBIB -eq 1 ] ; then
    echo "Extract persons"
    reshaperdf extractresources "$SWISSBIB_TMP_DATA_FOLDER/swissbib_sorted_wo_dup.nt" "$LINKED_TMP_DATA_FOLDER/swissbib_persons_all.nt" \
                http://www.w3.org/1999/02/22-rdf-syntax-ns#type http://xmlns.com/foaf/0.1/Person 0 -1 &> "$LINKED_LOGGING/sb_extract_persons.log"

    RETURN_STATUS=$?

    if [ "$RETURN_STATUS" -eq 0 ]; then
      echo "Extract persons ok."
    else
      echo "Error during extraction of persons. Exiting." 1>&2
      exit "$RETURN_STATUS"
    fi
fi

if [ $EXTRACT_ORGANISATIONS_SWISSBIB -eq 1 ] ; then
    echo "Extract Organizations"
    reshaperdf extractresources "$SWISSBIB_TMP_DATA_FOLDER/swissbib_sorted_wo_dup.nt" "$LINKED_TMP_DATA_FOLDER/swissbib_organizations_all.nt" \
                http://www.w3.org/1999/02/22-rdf-syntax-ns#type http://xmlns.com/foaf/0.1/Organization 0 -1 &> "$LINKED_LOGGING/sb_extract_organizations.log"

    RETURN_STATUS=$?

    if [ "$RETURN_STATUS" -eq 0 ]; then
      echo "Extracting organizations ok."
    else
      echo "Error during extraction of organizations. Exiting." 1>&2
      exit "$RETURN_STATUS"
    fi
fi


if [ $FILTER_PERSONS_FOR_LINKING_SWISSBIB -eq 1 ] ; then
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
fi # END FILTER_FOR_LINKING_SWISSBIB


if [ $BLOCK_PERSONS_BY_LAST_NAME -eq 1 ] ; then
    echo "Block persons by last name"
    rm -rf "$LINKED_TMP_DATA_FOLDER/swissbib_blocks"
    mkdir -p "$LINKED_TMP_DATA_FOLDER/swissbib_blocks"
    reshaperdf block "$LINKED_TMP_DATA_FOLDER/swissbib_persons_for_linking.nt" "$LINKED_TMP_DATA_FOLDER/swissbib_blocks" \
                        http://xmlns.com/foaf/0.1/lastName 0 1 \
                        &> "$LINKED_LOGGING/sb_block_last_name_persons.log"

    RETURN_STATUS=$?

    if [ "$RETURN_STATUS" -eq 0 ]; then
      echo "Blocking persons by last name ok."
    else
      echo "Error during blocking of persons by last name. Exiting." 1>&2
      exit "$RETURN_STATUS"
    fi
fi

if [ $BLOCK_PERSONS_BY_GND -eq 1 ] ; then
    echo "Block persons by gnd identifier"
    rm -rf "$LINKED_TMP_DATA_FOLDER/swissbib_gnd_blocks"
    mkdir -p "$LINKED_TMP_DATA_FOLDER/swissbib_gnd_blocks"
    reshaperdf block "$LINKED_TMP_DATA_FOLDER/swissbib_persons_for_linking.nt" "$LINKED_TMP_DATA_FOLDER/swissbib_gnd_blocks" \
                        http://www.w3.org/2002/07/owl#sameAs 21 3 \
                        &> "$LINKED_LOGGING/sb_block_gnd_persons.log"

    RETURN_STATUS=$?

    if [ "$RETURN_STATUS" -eq 0 ]; then
        echo "Blocking persons by gnd identifier ok."
    else
        echo "Error during blocking of persons by gnd identifier. Exiting." 1>&2
        exit "$RETURN_STATUS"
    fi
fi

# Log end time
echo -n "End swissbib process: " >> "$LINKED_LOGGING/process.log"
date >> "$LINKED_LOGGING/process.log"
echo "Done swissbib process"
exit "$RETURN_STATUS"
