#!/bin/bash
#10.12.15
#bensmafx

#Takes the link file and extracts the enrichment from dbpedia


# Log start time
echo -n "Start: " >> times_postprocess.log
date >> times_postprocess.log


rm viaf_enrichment.nt viaf_ends.nt

echo Get enrichment
reshaperdf getenrichment link_file.nt viaf_persons_4_enrichment.nt viaf_enrichment.nt &>links_getenrichment.log

echo Get loose ends from gender infos
reshaperdf securelooseends viaf_enrichment.nt external_data_sorted.nt viaf_ends.nt http://schema.org/gender http://linked.swissbib.ch/vocab/schemaGenderAsLiteral

# Log end time
echo -n "End: " >> times_postprocess.log
date >> times_postprocess.log


echo done
