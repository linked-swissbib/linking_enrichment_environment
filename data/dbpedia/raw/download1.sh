#!/bin/bash
#18.11.15
#bensmafx
#Script to download DBPedia dumps

# Store start time
echo -n "Start: " >> times.log
date >> times.log


#Download canonical data ###########################################################################
####################################################################################################

#Mapping based types - de
wget -nv http://downloads.dbpedia.org/2016-04/core-i18n/de/instance-types-en-uris_de.nt.bz2
#Maping based properties - de
wget -nv http://downloads.dbpedia.org/2016-04/core-i18n/de/mappingbased-properties-en-uris_de.nt.bz2
#Persondata - de
wget -nv http://downloads.dbpedia.org/2016-04/core-i18n/de/persondata-en-uris_de.nt.bz2
#Extended abstracts
wget -nv http://downloads.dbpedia.org/2016-04/core-i18n/de/long-abstracts-en-uris_de.nt.bz2
#Images
wget -nv http://downloads.dbpedia.org/2016-04/core-i18n/de/images-en-uris_de.nt.bz2
#Labels
wget -nv http://downloads.dbpedia.org/2016-04/core-i18n/de/labels-en-uris_de.nt.bz2



#Mapping based types - en
wget -nv http://downloads.dbpedia.org/2016-04/core-i18n/en/instance-types_en.nt.bz2
#Mapping based properties - en
wget -nv http://downloads.dbpedia.org/2016-04/core-i18n/en/mappingbased-properties_en.nt.bz2
#Person data - en
wget -nv http://downloads.dbpedia.org/2016-04/core-i18n/en/persondata_en.nt.bz2
#Extended abstracts
wget -nv http://downloads.dbpedia.org/2016-04/core-i18n/en/long-abstracts_en.nt.bz2
#Images
wget -nv http://downloads.dbpedia.org/2016-04/core-i18n/en/images_en.nt.bz2
#Labels
wget -nv http://downloads.dbpedia.org/2016-04/core-i18n/en/labels_en.nt.bz2

wait


echo -n "first part of Download complete: " >> times.log
date >> times.log



echo Unzipping...


#unzip files
bzip2 -k -d *.nt.bz2

wait

rm *.bz2


# Store end time
echo -n "End: " >> times.log
date >> times.log



echo Done

