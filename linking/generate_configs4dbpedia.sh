#!/bin/bash
#bensmafx
#4.8.16

# Generates the configuration files for limes linking.


echo "Generate limes configurations for dbpedia."

source ././../paths/load_path_variables.sh

ROOT_DIRECTORY=..
GENCONFIG_JAR="$ROOT_DIRECTORY/apps/genconfig/genconfig-1.1-all.jar"
OUTPUT="$LINKED_TMP_DATA_FOLDER/linking"

if [ ! -d $OUTPUT ] ; then
    mkdir "$OUTPUT"
else
    rm "$OUTPUT/*"
fi

# ensure there is an empty configs directory for output files
rm -rf "$ROOT_DIRECTORY/linking/configs"
mkdir "$ROOT_DIRECTORY/linking/configs"

# firstname - lastname - birthdate
echo java -jar "$GENCONFIG_JAR" "$LINKED_TMP_DATA_FOLDER/swissbib_blocks" "$LINKED_TMP_DATA_FOLDER/dbpedia_blocks" \
            "$ROOT_DIRECTORY/linking/templates/swissbib-dbpedia_birthDate.xml" "$ROOT_DIRECTORY/linking/configs"\
            "$OUTPUT"

# firstname - lastname
#java -jar $root_dir/genconfig-tool/genconfig-1.0-SNAPSHOT.jar limes $root_dir/data/swissbib/swissbib_blocks $root_dir/data/dbpedia/dbpedia_blocks $root_dir/linking/templates/swissbib-dbpedia.xml.template $root_dir/linking/configs

# firstname - lastname - birthdate - deathdate
#java -jar $root_dir/genconfig-tool/genconfig-1.0-SNAPSHOT.jar limes $root_dir/data/swissbib/swissbib_blocks $root_dir/data/dbpedia/dbpedia_blocks $root_dir/linking/templates/swissbib-dbpedia_birthDate_deathDate.xml.template $root_dir/linking/configs

echo "Finished generating limes configurations."
