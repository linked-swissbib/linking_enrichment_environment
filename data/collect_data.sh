#!/bin/bash
#bensmafx
#15.8.16

# Script collects all data for final output

# Log start time
echo -n "Start: " >>times_collect.log
date >> times_collect.log


cat swissbib/swissbib_persons_all.nt swissbib/swissbib_organizations_all.nt dbpedia/link_file.nt dbpedia/dbpedia_enrichment.nt dbpedia/dbpedia_ends.nt viaf/viaf_enrichment.nt viaf/viaf_ends.nt viaf/link_file.nt > swissbib_out.nt
reshaperdf sort swissbib_out.nt swissbib_out_sorted.nt

rm swissbib_out.nt

# Log end time
echo -n "End: " >>times_collect.log
date >> times_collect.log


echo Done

