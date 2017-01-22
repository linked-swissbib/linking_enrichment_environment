#!/bin/bash
#10.12.15
#bensmafx

#Script to isolate the linked persons and their documents


#get linked persons ids
#reshaperdf pick2 results/links2viaf_160531.nt roundtriptest/viaf_persons.txt o ? http://www.w3.org/2002/07/owl#sameAs ?

#get works
#reshaperdf pick2 viaf.nt roundtriptest/viaf_docs.nt stmt ? list_creation_predicates.txt ?

#get authros with works
reshaperdf pick2 roundtriptest/viaf_docs.nt roundtriptest/ref_autors.txt o ? ? roundtriptest/viaf_persons.txt

echo done
