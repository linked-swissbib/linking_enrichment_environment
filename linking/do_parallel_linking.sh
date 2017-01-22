#!/bin/bash
#bensmafx
#02.11.15
#Script does a crosslinking with Limes


# Log start time
echo -n "Start: " >> time.log
date >> time.log

source load_locations.sh


#collect all config files
#configlist=$(find /home/bensmafx/Linking/limes/LIMES/RC4/blocking/configs -type f )
configlist=$(find $configs_dir -type f )

#counter
cnt=0
parallel_processes=20

#remove cached data
rm -rf cache

#do block linking
for config in $configlist
do
    java -Xmx10g -jar $limes_app $config &
    ((cnt=$cnt+1))
    ((tmp = $cnt % $parallel_processes))
    if [ "$tmp" = "0" ]; then
        echo Waiting for processes
        wait
    fi
done
echo Waiting for processes
wait

cat $configs_dir/accept* > accept_all.nt
rm -rf $configs_dir
reshaperdf sort accept_all.nt accept_all_sorted.nt
reshaperdf removeduplicates accept_all_sorted.nt accepted.nt
rm accept_all.nt accept_all_sorted.nt 

  
# Log end time
echo -n "End: " >> time.log
date >> time.log



echo Done.

