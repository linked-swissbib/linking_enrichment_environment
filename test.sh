#!/usr/bin/env bash


source ./paths/load_path_variables.sh
CONFIG_DIR="swissbib/config"

echo "Block persons by gnd identifier"
mkdir -p "$LINKED_TMP_DATA_FOLDER/swissbib_gnd_blocks"
reshaperdf block "$LINKED_TMP_DATA_FOLDER/swissbib_persons_for_linking.nt" "$LINKED_TMP_DATA_FOLDER/swissbib_gnd_blocks" http://www.w3.org/2002/07/owl#sameAs 21 3 &> "$LINKED_LOGGING/block_gnd_persons.log"
