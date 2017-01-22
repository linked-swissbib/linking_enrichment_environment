#!/bin/bash
#bensmafx
#16.8.16

# Executes the linking workflow

cwd=`pwd`


# Log start time
echo -n "Start: " >> times.log
date >> times.log


# Preprocess swissbib
cd $cwd/data/swissbib
./preprocess_swissbib.sh
status=$?
if [ $status -eq 0 ]; then
  echo Preprocessing Swissbib ok.
else
  echo Error during preprocessing of Swissbib. Exiting. 1>&2
  exit $status
fi





# Link with DBpedia
cd $cwd/linking
./generate_configs4dbpedia.sh
status=$?
if [ $status -eq 0 ]; then
  echo Generating configuration files for interlinking whith DBpedia ok.
else
  echo Error during generation of configuration file for interlinking with DBpedia. Exiting. 1>&2
  exit $status
fi

./do_parallel_linking.sh
status=$?
if [ $status -eq 0 ]; then
  echo Parallel interlinking with DBpedia ok.
else
  echo Error during parallel interlinking with DBpedia. Exiting. 1>&2
  exit $status
fi

mv accepted.nt $cwd/data/dbpedia/link_file.nt

# Get DBpedia enrichment
cd $cwd/data/dbpedia
./postprocess_dbpedia.sh 
status=$?
if [ $status -eq 0 ]; then
  echo Enriching with DBpedia ok.
else
  echo Error during enrichment with DBpedia. Exiting. 1>&2
  exit $status
fi





# Link with Viaf normal
cd $cwd/linking
./generate_configs4viaf.sh
status=$?
if [ $status -eq 0 ]; then
  echo "Generating configuration files for interlinking with VIAF (FN-LN-BD) ok."
else
  echo "Error during generation of configuration files for interlinking with VIAF (FN-LN-DB). Exiting." 1>&2
  exit $status
fi

./do_parallel_linking.sh
status=$?
if [ $status -eq 0 ]; then
  echo "Parallel interlinkin with VIAF (FN-LN-BD) ok."
else
  echo "Error during parallel interlinking with VIAF (FN-LN-BD). Exiting." 1>&2
  exit $status
fi

mv accepted.nt accepted_normal.nt


# Link with Viaf gnd ids
./generate_configs4viaf_gndids.sh
status=$?
if [ $status -eq 0 ]; then
  echo "Parallel interlinkin with VIAF (GND-ID) ok."
else
  echo "Error during parallel interlinking with VIAF (GND-ID). Exiting." 1>&2
  exit $status
fi

./do_parallel_linking.sh
status=$?
if [ $status -eq 0 ]; then
  echo "Parallel interlinkin with VIAF (GND-ID) ok."
else
  echo "Error during parallel interlinking with VIAF (GND-ID). Exiting." 1>&2
  exit $status
fi

mv accepted.nt accepted_gnd.nt

# Merge link files
cat accepted_normal.nt accepted_gnd.nt > accepted.nt
reshaperdf sort accepted.nt accepted_sorted.nt
reshaperdf removeduplicates accepted_sorted.nt accepted_wodup.nt
rm accepted_normal.nt accepted_gnd.nt accepted_sorted.nt
mv accepted_wodup.nt $cwd/data/viaf/link_file.nt


# Get Viaf enrichment
cd $cwd/data/viaf
./postprocess_viaf.sh
status=$?
if [ $status -eq 0 ]; then
  echo "Enriching with VIAF ok."
else
  echo "Error during enrichmetn with VIAF. Exiting." 1>&2
  exit $status
fi



# Write final output
cd $cwd/data
./collect_data.sh
status=$?
if [ $status -eq 0 ]; then
  echo "Merging original data, links and enrichment data ok."
else
  echo "Error during merging original data, links and enrichment data. Exiting." 1>&2
  exit $status
fi


# Log end time
echo -n "End: " >> times.log
date >> times.log

echo Done
exit 0


