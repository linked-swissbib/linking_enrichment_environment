#!/bin/bash
#11.01.2016
#bensmafx
#22.1.2017 guenterh

# Download VIAF authority data as N-Triples, URL may have to be updated when a new release is shipped by OCLC.

source ../paths/load_path_variables.sh

# Log start time
echo -n "Start download viaf data: " >> "$LINKED_LOGGING/viaf.log"
date >> "$LINKED_LOGGING/viaf.log"


echo "Download VIAF data."
# Download data
wget -P "$LINKED_VIAF_DATA_FOLDER" http://viaf.org/viaf/data/viaf-20180903-clusters-rdf.nt.gz

# Old Link http://viaf.org/viaf/data/viaf-20170101-clusters-rdf.nt.gz

# Log download compplete time
echo -n "Download complete: " >> "$LINKED_LOGGING/viaf.log"
date >> "$LINKED_LOGGING/viaf.log"


cd "$LINKED_VIAF_DATA_FOLDER"

#unzip data
gunzip *.gz

# remove links that contain double quotes '"' in the object URI
sed -i.BAK '/<http:\/\/viaf\.org\/viaf\/[0-9]*\/*> *<http:\/\/schema\.org\/sameAs> *<http:\/\/.*".*> *./d' "$LINKED_VIAF_DATA_FOLDER/viaf-[0-9]*-clusters-rdf.nt"


# Log end time
echo -n "End download viaf data: " >> "$LINKED_LOGGING/viaf.log"
date >> "$LINKED_LOGGING/viaf.log"

echo "Done downloading viaf data"
exit 0