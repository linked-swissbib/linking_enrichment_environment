#!/bin/bash
#11.01.2016
#bensmafx
#22.1.2017 guenterh

# Download Viaf authority data as N-Triples, URL may have to be updated when a new release is shipped by OCLC.


# Log start time
echo -n "Start: " >> times.log
date >> times.log


# Download data
wget -nv http://viaf.org/viaf/data/viaf-20170101-clusters-rdf.nt.gz

# Log download compplete time
echo -n "Download complete: " >> times.log
date >> times.log



#unzip data
gunzip *.gz

# remove links that contain double quotes '"' in the object URI
sed -i.BAK '/<http:\/\/viaf\.org\/viaf\/[0-9]*\/*> *<http:\/\/schema\.org\/sameAs> *<http:\/\/.*".*> *./d' viaf-[0-9]*-clusters-rdf.nt


# Log end time
echo -n "End: " >> times.log
date >> times.log



echo Done

