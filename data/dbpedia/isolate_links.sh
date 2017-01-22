#!/bin/bash
#10.12.15
#bensmafx

#Script to isolate the linked persons and their documents


#get linked persons ids
reshaperdf pick2 results/links2dbpedia_20160106.nt roundtriptest/dbp_persons.txt o ? http://www.w3.org/2002/07/owl#sameAs ?

#get links to docs
reshaperdf pick2 dbpedia_persons_all.nt roundtriptest/links_persons-docs.nt stmt roundtriptest/dbp_persons.txt list_creation_predicates_r.txt ?

#get works
reshaperdf pick2 dbpedia.nt roundtriptest/dbp_docs.nt res ? list_creation_predicates.txt ?

#get referenced works
reshaperdf pick2 roundtriptest/dbp_docs.nt roundtriptest/links_docs-persons.nt stmt ? list_creation_predicates.txt roundtriptest/dbp_persons.txt


echo done
