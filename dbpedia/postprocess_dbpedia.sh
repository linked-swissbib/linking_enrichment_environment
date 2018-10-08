#!/bin/bash
#10.12.15
#bensmafx

#Takes the link file and extracts the enrichment from dbpedia

source ./../paths/load_path_variables.sh

# Log start time
echo -n "Started post-processing dbpedia: " >> "$LINKED_LOGGING/process.log"
date >> "$LINKED_LOGGING/process.log"

echo "Get enrichment"
reshaperdf getenrichment "$LINKED_TMP_DATA_FOLDER/dbpedia_link_file.nt" "$LINKED_TMP_DATA_FOLDER/dbpedia_persons_for_enrichment.nt" \
                        "$LINKED_TMP_DATA_FOLDER/dbpedia_enrichment.nt" &> "$LINKED_LOGGING/dbpedia_links_enrichment.log"

echo "Get loose ends"
reshaperdf securelooseends "$LINKED_TMP_DATA_FOLDER/dbpedia_enrichment.nt" "$LINKED_TMP_DATA_FOLDER/dbpedia_sorted_wo_dup_renamed.nt" \
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

# Log end time
echo -n "Finished post-processing dbpedia: " >> "$LINKED_LOGGING/process.log"
date >> "$LINKED_LOGGING/process.log"

echo "Finished post-processing dbpedia"
exit 0
