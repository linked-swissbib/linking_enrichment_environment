#!/bin/bash
#bensmafx
#4.8.16

# Generates the configuration files for limes linking.

root_dir=..

# ensure there is an empty configs directory for output files
rm -rf $root_dir/linking/configs
mkdir $root_dir/linking/configs

# firstname - lastname - birthdate
java -jar $root_dir/genconfig-tool/genconfig-1.0-SNAPSHOT.jar limes $root_dir/data/swissbib/swissbib_blocks $root_dir/data/dbpedia/dbpedia_blocks $root_dir/linking/templates/swissbib-dbpedia_birthDate.xml.template $root_dir/linking/configs

# firstname - lastname
#java -jar $root_dir/genconfig-tool/genconfig-1.0-SNAPSHOT.jar limes $root_dir/data/swissbib/swissbib_blocks $root_dir/data/dbpedia/dbpedia_blocks $root_dir/linking/templates/swissbib-dbpedia.xml.template $root_dir/linking/configs


# firstname - lastname - birthdate - deathdate
#java -jar $root_dir/genconfig-tool/genconfig-1.0-SNAPSHOT.jar limes $root_dir/data/swissbib/swissbib_blocks $root_dir/data/dbpedia/dbpedia_blocks $root_dir/linking/templates/swissbib-dbpedia_birthDate_deathDate.xml.template $root_dir/linking/configs




echo done

