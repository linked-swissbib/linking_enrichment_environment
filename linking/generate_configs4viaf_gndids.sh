#!/bin/bash
#bensmafx
#4.8.16

# Generates the configuration files for limes linking.

root_dir=..

# ensure there is an empty configs directory for output files
rm -rf $root_dir/linking/configs
mkdir $root_dir/linking/configs

# firstname - lastname - birthyear
#java -jar $root_dir/genconfig-tool/genconfig-1.0-SNAPSHOT.jar limes $root_dir/data/swissbib/swissbib_blocks $root_dir/data/viaf/viaf_blocks $root_dir/linking/templates/swissbib-viaf_birthYear.xml.template $root_dir/linking/configs


# firstname - lastname
#java -jar $root_dir/genconfig-tool/genconfig-1.0-SNAPSHOT.jar limes $root_dir/data/swissbib/swissbib_blocks $root_dir/data/viaf/viaf_blocks $root_dir/linking/templates/swissbib-viaf.xml.template $root_dir/linking/configs

# firstname - lastname - birthyear - deathyear
#java -jar $root_dir/genconfig-tool/genconfig-1.0-SNAPSHOT.jar limes $root_dir/data/swissbib/swissbib_blocks $root_dir/data/viaf/viaf_blocks $root_dir/linking/templates/swissbib-viaf_birthYear_deathYear.xml.template $root_dir/linking/configs

# firstname - lastname - birthyear - gnd identifier
java -jar $root_dir/genconfig-tool/genconfig-1.0-SNAPSHOT.jar limes $root_dir/data/swissbib/swissbib_gnd_blocks $root_dir/data/viaf/viaf_gnd_blocks $root_dir/linking/templates/swissbib-viaf_birthYear_gndidentifier.xml.template $root_dir/linking/configs





echo done

