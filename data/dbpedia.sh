#!/bin/bash
#18.11.15
#bensmafx
#Script to download DBPedia dumps

source ../paths/load_path_variables.sh

# Store start time
echo -n "Start dbpedia download: " >> "$LINKED_LOGGING/dbpedia.log"
date >> "$LINKED_LOGGING/dbpedia.log"


#Download canonical data ###########################################################################
####################################################################################################

### DE ###
#Mapping based types
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/de/instance_types_en_uris_de.ttl.bz2
#Mapping based properties: literals
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/de/mappingbased_literals_en_uris_de.ttl.bz2
#Mapping based properties: objects
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/de/mappingbased_objects_en_uris_de.ttl.bz2
#Persondata
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/de/persondata_en_uris_de.ttl.bz2
#Extended abstracts
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/de/long_abstracts_en_uris_de.ttl.bz2
#Images
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/de/images_en_uris_de.ttl.bz2
#Labels
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/de/labels_en_uris_de.ttl.bz2


### EN ###
#Mapping based types
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/en/instance_types_en.ttl.bz2
#Mapping based literals
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/en/mappingbased_literals_en.ttl.bz2
#Mapping based objects
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/en/mappingbased_objects_en.ttl.bz2
#Person data
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/en/persondata_en.ttl.bz2
#Extended abstracts
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/en/long_abstracts_en.ttl.bz2
#Images
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/en/images_en.ttl.bz2
#Labels
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/en/labels_en.ttl.bz2


### FR ###
#Mapping based types
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/fr/instance_types_en_uris_fr.ttl.bz2
#Mapping based literals
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/fr/mappingbased_literals_en_uris_fr.ttl.bz2
#Mapping based objects
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/fr/mappingbased_objects_en_uris_fr.ttl.bz2
#Extended abstracts
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/fr/long_abstracts_en_uris_fr.ttl.bz2
#Images
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/fr/images_en_uris_fr.ttl.bz2
#Labels
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/fr/labels_en_uris_fr.ttl.bz2


### IT ###
#Mapping based types
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/it/instance_types_en_uris_it.ttl.bz2
#Mapping based literals
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/it/mappingbased_literals_en_uris_it.ttl.bz2
#Mapping based objects
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/it/mappingbased_objects_en_uris_it.ttl.bz2
#Extended abstract
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/it/long_abstracts_en_uris_it.ttl.bz2
#Images
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/it/images_en_uris_it.ttl.bz2
#Labels
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/it/labels_en_uris_it.ttl.bz2




#Download localized data ############################################################################
######################################################################################################

### DE ###
#Mapping based types
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/de/instance_types_de.ttl.bz2
#Maping based literals
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/de/mappingbased_literals_de.ttl.bz2
#Mapping based objects
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/de/mappingbased_objects_de.ttl.bz2
#Extended abstracts
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/de/long_abstracts_de.ttl.bz2
#Images
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/de/images_de.ttl.bz2
#Labels
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/de/labels_de.ttl.bz2


### FR ###
#Mapping based types
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/fr/instance_types_fr.ttl.bz2
#Mapping based literals
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/fr/mappingbased_literals_fr.ttl.bz2
#Mapping based objects
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/fr/mappingbased_objects_fr.ttl.bz2
#Extended abstracts
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/fr/long_abstracts_fr.ttl.bz2
#Images
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/fr/images_fr.ttl.bz2
#Labels
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/fr/labels_fr.ttl.bz2


### IT ###
#Mapping based types
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/it/instance_types_it.ttl.bz2
#Mapping based literals
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/it/mappingbased_literals_it.ttl.bz2
#Mapping based objects
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/it/mappingbased_objects_it.ttl.bz2
#Extended abstracts
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/it/long_abstracts_it.ttl.bz2
#Images
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/it/images_it.ttl.bz2
#Labels
wget -nv -N -P "$LINKED_DBPEDIA_DATA_FOLDER" http://downloads.dbpedia.org/2016-04/core-i18n/it/labels_it.ttl.bz2

wait

# Store download done time
echo -n "Download complete: " >> "$LINKED_LOGGING/dbpedia.log"
date >> "$LINKED_LOGGING/dbpedia.log"


echo "Unzipping..."

cd "$LINKED_DBPEDIA_DATA_FOLDER"

bzip2 -k -d *.ttl.bz2

wait

rm *.bz2

# Store end time
echo -n "DBpedia Data Ready: " >> "$LINKED_LOGGING/dbpedia.log"
date >> "$LINKED_LOGGING/dbpedia.log"



echo Done

