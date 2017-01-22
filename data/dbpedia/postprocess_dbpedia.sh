#!/bin/bash
#10.12.15
#bensmafx

#Takes the link file and extracts the enrichment from dbpedia


# Log start time
echo -n "Start: " >> times_postprocess.log
date >> times_postprocess.log


rm dbpedia_enrichment.nt dbpedia_ends.nt

echo Get enrichment
reshaperdf getenrichment link_file.nt dbpedia_persons_4_enrichment.nt dbpedia_enrichment.nt &>links_getenrichment.log

echo Get loose ends
reshaperdf securelooseends dbpedia_enrichment.nt dbpedia_sorted_wo_dup_renamed.nt dbpedia_ends.nt http://dbpedia.org/ontology/birthPlace http://linked.swissbib.ch/vocab/dbpBirthPlaceAsLiteral http://dbpedia.org/ontology/deathPlace http://linked.swissbib.ch/vocab/dbpDeathPlaceAsLiteral http://dbpedia.org/ontology/genre http://linked.swissbib.ch/vocab/dbpGenreAsLiteral http://dbpedia.org/ontology/movement http://linked.swissbib.ch/vocab/dbpMovementAsLiteral http://dbpedia.org/ontology/nationality http://linked.swissbib.ch/vocab/dbpNationalityAsLiteral http://dbpedia.org/ontology/occupation http://linked.swissbib.ch/vocab/dbpOccupationAsLiteral http://dbpedia.org/ontology/partner http://linked.swissbib.ch/vocab/dbpPartnerAsLiteral http://dbpedia.org/ontology/spouse http://linked.swissbib.ch/vocab/dbpSpouseAsLiteral http://dbpedia.org/ontology/influencedBy http://linked.swissbib.ch/vocab/dbpInfluencedByAsLiteral http://dbpedia.org/ontology/influenced http://linked.swissbib.ch/vocab/dbpInfluencedAsLiteral http://dbpedia.org/ontology/notableWork http://linked.swissbib.ch/vocab/dbpNotableWorkAsLiteral &>secure_ends.log

# Log end time
echo -n "End: " >> times_postprocess.log
date >> times_postprocess.log

echo done


