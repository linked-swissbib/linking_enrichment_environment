#!/bin/bash
#10.12.15
#bensmafx

#Script to process swissbib data for linking



echo Converting data
context_dir=contexts
context_prefix=http://data.swissbib.ch
reshaperdf ntriplify /swissbib_index/lsbPlatform/data/baseLineOutput swissbib_dump_complete.nt $context_prefix/document/context.jsonld $context_dir/document/context.jsonld $context_prefix/item/context.jsonld $context_dir/item/context.jsonld $context_prefix/organisation/context.jsonld $context_dir/organisation/context.jsonld $context_prefix/person/context.jsonld $context_dir/person/context.jsonld $context_prefix/resource/context.jsonld $context_dir/resource/context.jsonld $context_prefix/work/context.jsonld $context_dir/work/context.jsonld &>convert.log

echo Done

