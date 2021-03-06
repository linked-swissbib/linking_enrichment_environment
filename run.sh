#!/bin/bash
#bensmafx
#16.8.16

PREPROCESS_SWISSBIB=0
LINK_DBPEDIA=1
LINK_VIAF_NAME=0
LINK_VIAF_GND=0
POSTPROCESS_DATA=0

# Executes the linking workflow

CURRENT_WORKING_DIRECTORY=$(pwd)

source ./paths/load_path_variables.sh

# remove all temporary files created from last run.
# rm "$LINKED_TMP_DATA_FOLDER/"

# The start time of the process.
echo -n "Start process: " >> "$LINKED_LOGGING/process.log"
date >> "$LINKED_LOGGING/process.log"


if [ $PREPROCESS_SWISSBIB -eq 1 ] ; then
    # Pre-process_swissbib_data
    cd "$CURRENT_WORKING_DIRECTORY/swissbib"
    # RUN
    ./preprocess_swissbib.sh
    STATUS=$?
    if [ "$STATUS" -eq 0 ]; then
      echo Preprocessing Swissbib ok.
    else
      echo Error during preprocessing of Swissbib. Exiting. 1>&2
      exit "$STATUS"
fi
fi

cd "$CURRENT_WORKING_DIRECTORY/linking"

if [ $LINK_DBPEDIA -eq 1 ] ; then
    # RUN
    ./generate_configs4dbpedia.sh

    STATUS=$?

    if [ "$STATUS" -eq 0 ]; then
      echo "Generating configuration files for interlinking whith DBpedia ok."
    else
      echo "Error during generation of configuration file for interlinking with DBpedia. Exiting." 1>&2
      exit "$STATUS"
    fi

    ./do_parallel_linking.sh

    STATUS=$?

    if [ "$STATUS" -eq 0 ]; then
      echo "Parallel interlinking with DBpedia ok."
    else
      echo "Error during parallel interlinking with DBpedia. Exiting." 1>&2
      exit "$STATUS"
    fi

    mv "$LINKED_TMP_DATA_FOLDER/accepted.nt" "$LINKED_TMP_DATA_FOLDER/dbpedia_link_file.nt"

    # Get DBpedia enrichment
    cd "$CURRENT_WORKING_DIRECTORY/dbpedia"

    ./postprocess_dbpedia.sh

    STATUS=$?

    if [ "$STATUS" -eq 0 ]; then
      echo "Enriching with DBpedia ok."
    else
      echo "Error during enrichment with DBpedia. Exiting." 1>&2
      exit "$STATUS"
    fi
fi # END LINK DBPEDIA

if [ $LINK_VIAF_NAME -eq 1 ] ; then
    # Link with Viaf normal
    cd "$CURRENT_WORKING_DIRECTORY/linking"

    ./generate_configs4viaf.sh

    STATUS=$?

    if [ "$STATUS" -eq 0 ]; then
      echo "Generating configuration files for interlinking with VIAF (FN-LN-BD) ok."
    else
      echo "Error during generation of configuration files for interlinking with VIAF (FN-LN-DB). Exiting." 1>&2
      exit "$STATUS"
    fi

    ./do_parallel_linking.sh

    STATUS=$?

    if [ "$STATUS" -eq 0 ]; then
      echo "Parallel inter-linking with VIAF (FN-LN-BD) ok."
    else
      echo "Error during parallel inter-linking with VIAF (FN-LN-BD). Exiting." 1>&2
      exit "$STATUS"
    fi

    mv "$LINKED_TMP_DATA_FOLDER/accepted.nt" "$LINKED_TMP_DATA_FOLDER/viaf_normal_link_file.nt"

fi # END LINK VIAF NAME

if [ $LINK_VIAF_GND -eq 1 ] ; then
    # Link with Viaf gnd ids
    ./generate_configs4viaf_gndids.sh

    STATUS=$?

    if [ "$STATUS" -eq 0 ]; then
      echo "Parallel interlinkin with VIAF (GND-ID) ok."
    else
      echo "Error during parallel interlinking with VIAF (GND-ID). Exiting." 1>&2
      exit "$STATUS"
    fi

    ./do_parallel_linking.sh

    STATUS=$?

    if [ "$STATUS" -eq 0 ]; then
      echo "Parallel interlinkin with VIAF (GND-ID) ok."
    else
      echo "Error during parallel interlinking with VIAF (GND-ID). Exiting." 1>&2
      exit "$STATUS"
    fi

    mv "$LINKED_TMP_DATA_FOLDER/accepted.nt" "$LINKED_TMP_DATA_FOLDER/viaf_gnd_link_file.nt"
fi # END LINK VIAF GND

# Merge link files
cat "$LINKED_TMP_DATA_FOLDER/viaf_normal_link_file.nt" "$LINKED_TMP_DATA_FOLDER/viaf_gnd_link_file.nt" > "$LINKED_TMP_DATA_FOLDER/accepted.nt"
reshaperdf sort "$LINKED_TMP_DATA_FOLDER/accepted.nt" "$LINKED_TMP_DATA_FOLDER/accepted_sorted.nt"
reshaperdf removeduplicates "$LINKED_TMP_DATA_FOLDER/accepted_sorted.nt" "$LINKED_TMP_DATA_FOLDER/accepted_wo_dup.nt"
rm "$LINKED_TMP_DATA_FOLDER/viaf_normal_link_file.nt" "$LINKED_TMP_DATA_FOLDER/viaf_gnd_link_file.nt" "$LINKED_TMP_DATA_FOLDER/accepted_sorted.nt"
mv "$LINKED_TMP_DATA_FOLDER/accepted_wo_dup.nt" "$LINKED_TMP_DATA_FOLDER/viaf_link_file.nt"

# Get Viaf enrichment
cd "$CURRENT_WORKING_DIRECTORY/viaf"

# RUN
./postprocess_viaf.sh

STATUS=$?

if [ "$STATUS" -eq 0 ]; then
  echo "Enriching with VIAF ok."
else
  echo "Error during enrichmetn with VIAF. Exiting." 1>&2
  exit "$STATUS"
fi

# Write final output
cd "$CURRENT_WORKING_DIRECTORY/output"

./collect_data.sh

STATUS=$?

if [ "$STATUS" -eq 0 ]; then
  echo "Merging original data, links and enrichment data ok."
else
  echo "Error during merging original data, links and enrichment data. Exiting." 1>&2
  exit "$STATUS"
fi
fi # END POSTPROCESS

# Log end time
echo -n "End process: " >> "$LINKED_LOGGING/process.log"
date >> "$LINKED_LOGGING/process.log"

echo Done
exit 0