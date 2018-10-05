#!/bin/bash
#bensmafx
#16.8.16

# Executes the linking workflow

CURRENT_WORKING_DIRECTORY=$(pwd)


rm "$LINKED_LOGGING/*.log"
rm "$LINKED_TMP_DATA_FOLDER/*.nt"

# Log start time
echo -n "Start: " >> times.log
date >> times.log

# Preprocess prepare_swissbib_data
cd "$CURRENT_WORKING_DIRECTORY/prepare_swissbib_data"
./preprocess_swissbib.sh
STATUS=$?
if [ "$STATUS" -eq 0 ]; then
  echo Preprocessing Swissbib ok.
else
  echo Error during preprocessing of Swissbib. Exiting. 1>&2
  exit "$STATUS"
fi





# Link with DBpedia
cd $CURRENT_WORKING_DIRECTORY/linking
./generate_configs4dbpedia.sh
STATUS=$?
if [ $STATUS -eq 0 ]; then
  echo Generating configuration files for interlinking whith DBpedia ok.
else
  echo Error during generation of configuration file for interlinking with DBpedia. Exiting. 1>&2
  exit $STATUS
fi

./do_parallel_linking.sh
STATUS=$?
if [ $STATUS -eq 0 ]; then
  echo Parallel interlinking with DBpedia ok.
else
  echo Error during parallel interlinking with DBpedia. Exiting. 1>&2
  exit $STATUS
fi

mv accepted.nt $CURRENT_WORKING_DIRECTORY/data/dbpedia/link_file.nt

# Get DBpedia enrichment
cd $CURRENT_WORKING_DIRECTORY/data/dbpedia
./postprocess_dbpedia.sh 
STATUS=$?
if [ $STATUS -eq 0 ]; then
  echo Enriching with DBpedia ok.
else
  echo Error during enrichment with DBpedia. Exiting. 1>&2
  exit $STATUS
fi





# Link with Viaf normal
cd $CURRENT_WORKING_DIRECTORY/linking
./generate_configs4viaf.sh
STATUS=$?
if [ $STATUS -eq 0 ]; then
  echo "Generating configuration files for interlinking with VIAF (FN-LN-BD) ok."
else
  echo "Error during generation of configuration files for interlinking with VIAF (FN-LN-DB). Exiting." 1>&2
  exit $STATUS
fi

./do_parallel_linking.sh
STATUS=$?
if [ $STATUS -eq 0 ]; then
  echo "Parallel interlinkin with VIAF (FN-LN-BD) ok."
else
  echo "Error during parallel interlinking with VIAF (FN-LN-BD). Exiting." 1>&2
  exit $STATUS
fi

mv accepted.nt accepted_normal.nt


# Link with Viaf gnd ids
./generate_configs4viaf_gndids.sh
STATUS=$?
if [ $STATUS -eq 0 ]; then
  echo "Parallel interlinkin with VIAF (GND-ID) ok."
else
  echo "Error during parallel interlinking with VIAF (GND-ID). Exiting." 1>&2
  exit $STATUS
fi

./do_parallel_linking.sh
STATUS=$?
if [ $STATUS -eq 0 ]; then
  echo "Parallel interlinkin with VIAF (GND-ID) ok."
else
  echo "Error during parallel interlinking with VIAF (GND-ID). Exiting." 1>&2
  exit $STATUS
fi

mv accepted.nt accepted_gnd.nt

# Merge link files
cat accepted_normal.nt accepted_gnd.nt > accepted.nt
reshaperdf sort accepted.nt accepted_sorted.nt
reshaperdf removeduplicates accepted_sorted.nt accepted_wodup.nt
rm accepted_normal.nt accepted_gnd.nt accepted_sorted.nt
mv accepted_wodup.nt $CURRENT_WORKING_DIRECTORY/data/viaf/link_file.nt


# Get Viaf enrichment
cd $CURRENT_WORKING_DIRECTORY/data/viaf
./postprocess_viaf.sh
STATUS=$?
if [ $STATUS -eq 0 ]; then
  echo "Enriching with VIAF ok."
else
  echo "Error during enrichmetn with VIAF. Exiting." 1>&2
  exit $STATUS
fi



# Write final output
cd $CURRENT_WORKING_DIRECTORY/data
./collect_data.sh
STATUS=$?
if [ $STATUS -eq 0 ]; then
  echo "Merging original data, links and enrichment data ok."
else
  echo "Error during merging original data, links and enrichment data. Exiting." 1>&2
  exit $STATUS
fi


# Log end time
echo -n "End: " >> times.log
date >> times.log

echo Done
exit 0