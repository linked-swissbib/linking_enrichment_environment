#!/bin/bash
#10.12.15
#bensmafx

#Script to process swissbib_data for linking

source ./../paths/load_path_variables.sh

echo "Converting data"
CONTEXT_DIRECTORY=config/contexts
CONTEXT_PREFIX=http://data.swissbib.ch
reshaperdf ntriplify "$LINKED_TARGET_DATA_FOLDER" "$LINKED_TMP_DATA_FOLDER/swissbib_dump_complete.nt" \
        "$CONTEXT_PREFIX/document/context.jsonld" "$CONTEXT_DIRECTORY/document/context.jsonld" \
        "$CONTEXT_PREFIX/item/context.jsonld" "$CONTEXT_DIRECTORY/item/context.jsonld" \
        "$CONTEXT_PREFIX/organisation/context.jsonld" "$CONTEXT_DIRECTORY/organisation/context.jsonld" \
        "$CONTEXT_PREFIX/person/context.jsonld" "$CONTEXT_DIRECTORY/person/context.jsonld" \
        "$CONTEXT_PREFIX/resource/context.jsonld" "$CONTEXT_DIRECTORY/resource/context.jsonld" \
        "$CONTEXT_PREFIX/work/context.jsonld" "$CONTEXT_DIRECTORY/work/context.jsonld"
        &> "$LINKED_LOGGING/convert.log"

echo "Done converting data."

