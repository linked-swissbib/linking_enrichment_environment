#!/bin/bash
#bensmafx
#15.8.16

# Saves the places of the locations used for linking; to be used in other scripts

if [ `whoami` == bensmafx ]; then
	echo Using settings for development environment.
	export configs_dir=/home/bensmafx/Linking/limes/LIMES/RC4/blocking/configs
	export limes_app=/home/bensmafx/Linking/limes/LIMES/RC4/blocking/LIMES.jar
elif [ `whoami` == swissbib ]; then
	echo Using settings for productive environment
	export configs_dir=/swissbib_index/linking/linking/configs
	export limes_app=/swissbib_index/linking/limes-tool/LIMES.jar
else
	>&2 echo Unrecognized user name.
fi


