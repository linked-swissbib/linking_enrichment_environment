#!/bin/bash
#bensmafx
#4.8.16

# Generates the configuration files for limes linking.


echo "Generate limes configurations for viaf."

source ././../paths/load_path_variables.sh

ROOT_DIRECTORY=..
GENCONFIG_JAR="$ROOT_DIRECTORY/apps/genconfig/genconfig-1.0-SNAPSHOT-all.jar"

# ensure there is an empty configs directory for output files
rm -rf "$ROOT_DIRECTORY/linking/configs"
mkdir "$ROOT_DIRECTORY/linking/configs"

# firstname - lastname - birthyear
#java -jar $root_dir/genconfig-tool/genconfig-1.0-SNAPSHOT.jar limes $root_dir/data/swissbib/swissbib_blocks $root_dir/data/viaf/viaf_blocks $root_dir/linking/templates/swissbib-viaf_birthYear.xml $root_dir/linking/configs


# firstname - lastname
#java -jar $root_dir/genconfig-tool/genconfig-1.0-SNAPSHOT.jar limes $root_dir/data/swissbib/swissbib_blocks $root_dir/data/viaf/viaf_blocks $root_dir/linking/templates/swissbib-viaf.xml.template $root_dir/linking/configs

# firstname - lastname - birthyear - deathyear
#java -jar $root_dir/genconfig-tool/genconfig-1.0-SNAPSHOT.jar limes $root_dir/data/swissbib/swissbib_blocks $root_dir/data/viaf/viaf_blocks $root_dir/linking/templates/swissbib-viaf_birthYear_deathYear.xml.template $root_dir/linking/configs

# firstname - lastname - birthyear - gnd identifier
java -jar "$GENCONFIG_JAR" limes "$LINKED_TMP_DATA_FOLDER/swissbib_gnd_blocks" "$LINKED_TMP_DATA_FOLDER/viaf_gnd_blocks" \
                "$ROOT_DIRECTORY/linking/templates/swissbib-viaf_birthYear_gndidentifier.xml" "$ROOT_DIRECTORY/linking/configs"





echo done

