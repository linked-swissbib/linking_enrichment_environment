#!/bin/bash
#bensmafx
#02.03.2016
#Script that invokes reshaper securelooseends to reduce certain resources to particular literals

source ./../paths/load_path_variables.sh

echo "Securing loose ends"

reshaperdf securelooseends "$LINKED_TMP_DATA_FOLDER/dbpedia_enrichment.nt" "$LINKED_TMP_DATA_FOLDER/dbpedia_sorted_wo_dup.nt" \
                "$LINKED_TMP_DATA_FOLDER/dbpedia_ends.nt" \
                http://dbpedia.org/ontology/birthPlace http://linked.swissbib.ch/vocab/dbpBirthPlaceAsLiteral \
                http://dbpedia.org/ontology/deathPlace http://linked.swissbib.ch/vocab/dbpDeathPlaceAsLiteral \
                http://dbpedia.org/ontology/genre http://linked.swissbib.ch/vocab/dbpGenreAsLiteral \
                http://dbpedia.org/ontology/movement http://linked.swissbib.ch/vocab/dbpMovementAsLiteral \
                http://dbpedia.org/ontology/nationality http://linked.swissbib.ch/vocab/dbpNationalityAsLiteral \
                http://dbpedia.org/ontology/occupation http://linked.swissbib.ch/vocab/dbpOccupationAsLiteral \
                http://dbpedia.org/ontology/partner http://linked.swissbib.ch/vocab/dbpPartnerAsLiteral \
                http://dbpedia.org/ontology/spouse http://linked.swissbib.ch/vocab/dbpSpouseAsLiteral \
                http://dbpedia.org/ontology/influencedBy http://linked.swissbib.ch/vocab/dbpInfluencedByAsLiteral \
                http://dbpedia.org/ontology/influenced http://linked.swissbib.ch/vocab/dbpInfluencedAsLiteral \
                http://dbpedia.org/ontology/notableWork http://linked.swissbib.ch/vocab/dbpNotableWorkAsLiteral \
                &> "$LINKED_LOGGING/dbpedia_secure_loose_ends.log"

echo "Finished securing loose ends."
exit 0