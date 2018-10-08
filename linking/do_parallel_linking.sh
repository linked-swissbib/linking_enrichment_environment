#!/bin/bash
#bensmafx
#02.11.15
#Script does a crosslinking with Limes

source ./../paths/load_path_variables.sh

# Log start time
echo -n "Start parallel linking: " >> "$LINKED_LOGGING/process.log"
date >> "$LINKED_LOGGING/process.log"

CONFIG_DIR=configs

ROOT_DIRECTORY=..
LIMES="$ROOT_DIRECTORY/apps/LIMES/limes-core-1.5.0.jar"

#collect all config files
#configlist=$(find /home/bensmafx/Linking/limes/LIMES/RC4/blocking/configs -type f )
CONFIG_FILE_LIST=$(find "$CONFIG_DIR" -type f )

#counter
COUNTER=0
NUMBER_OF_PROCESSES=20

#remove cached data
rm -rf cache

#do block linking
for CONFIG in "$CONFIG_FILE_LIST"
do
    java -Xmx10g -jar "$LIMES" "$CONFIG" &
    ((COUNTER=$COUNTER+1))
    ((tmp = $COUNTER % $NUMBER_OF_PROCESSES))
    if [ "$tmp" = "0" ]; then
        echo "Waiting for processes"
        wait
    fi
done
echo "Waiting for processes"
wait

cat "$CONFIG_DIR/accept*" > "$LINKED_TMP_DATA_FOLDER/accept_all.nt"
rm -rf "$CONFIG_DIR"
reshaperdf sort "$LINKED_TMP_DATA_FOLDER/accept_all.nt" "$LINKED_TMP_DATA_FOLDER/accept_all_sorted.nt"
reshaperdf removeduplicates "$LINKED_TMP_DATA_FOLDER/accept_all_sorted.nt" "$LINKED_TMP_DATA_FOLDER/accepted.nt"
rm "$LINKED_TMP_DATA_FOLDER/accept_all.nt" "$LINKED_TMP_DATA_FOLDER/accept_all_sorted.nt"

  
# Log end time
echo -n "End parallel linking: " >> "$LINKED_LOGGING/process.log"
date >> "$LINKED_LOGGING/process.log"



echo "Finished linking data with limes."

