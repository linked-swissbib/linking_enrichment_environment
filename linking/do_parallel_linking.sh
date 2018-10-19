#!/bin/bash
#bensmafx
#02.11.15
#Script does a crosslinking with Limes

source ./../paths/load_path_variables.sh

CURRENT_WORKING_DIRECTORY=$(pwd)

# Log start time
echo -n "Start parallel linking: " >> "$LINKED_LOGGING/process.log"
date >> "$LINKED_LOGGING/process.log"

CONFIG_DIR=configs
rm -rf cache


ROOT_DIRECTORY=..
LIMES="$ROOT_DIRECTORY/apps/LIMES/limes-core-1.5.0.jar"

CONFIG_FILE_LIST=$(find "$CONFIG_DIR" -type f )
# echo "LIMES Configs: $CONFIG_FILE_LIST"

#counter
COUNTER=0
NUMBER_OF_PROCESSES=5

#do block linking
for CONFIG in ${CONFIG_FILE_LIST}
do
    # echo "$CURRENT_WORKING_DIRECTORY/{CONFIG_FILE_LIST[0]}"
    java -Xmx10g -jar "$LIMES" "$CURRENT_WORKING_DIRECTORY/$CONFIG" -f "XML" -o "$LINKED_LOGGING/limes.log" &
    COUNTER=$((COUNTER + 1))
    VAR=$((COUNTER%$NUMBER_OF_PROCESSES))
    if (( VAR = NUMBER_OF_PROCESSES )) ; then
        echo "Waiting for processes $VAR"
        wait
    fi
done
echo "Waiting for processes"
wait

echo $(pwd)
cat $LINKED_TMP_DATA_FOLDER/linking/accept_* > "$LINKED_TMP_DATA_FOLDER/accept_all.nt"
cat $LINKED_TMP_DATA_FOLDER/linking/review_* > "$LINKED_TMP_DATA_FOLDER/review_all.nt"

reshaperdf sort "$LINKED_TMP_DATA_FOLDER/accept_all.nt" "$LINKED_TMP_DATA_FOLDER/accept_all_sorted.nt"

reshaperdf removeduplicates "$LINKED_TMP_DATA_FOLDER/accept_all_sorted.nt" "$LINKED_TMP_DATA_FOLDER/accepted.nt"

rm "$LINKED_TMP_DATA_FOLDER/accept_all.nt" "$LINKED_TMP_DATA_FOLDER/accept_all_sorted.nt"

# Log end time
echo -n "End parallel linking: " >> "$LINKED_LOGGING/process.log"
date >> "$LINKED_LOGGING/process.log"

echo "Finished linking data with limes."
exit 0