#!/bin/bash

# Easy error printing function
echoerr() { echo "$@" 1>&2; }

# Argument check
if [[ "$#" -ne 1 ]]; then
    echoerr "Use: $0 fichero_configuracion"
    exit -1
fi

# Check if config file exists
# TODO: See if it's required to test also if it's a file or a dir
if [[ ! -e "$@" ]]; then
    echoerr "El archivo '$1' no existe"
    exit -1
fi

# Name of the config file
FILE="$1"
LINE=1

# Reading loop
while read line; do
    # String --> Array of words
    IFS=" " read -a args <<< "$line"

    # Skip the line if it's a comment or an empty line
    if [[ "${args[0]}" == "#" || "${args[0]}" == "" ]]; then
	LINE=$(($LINE + 1))
	continue;
    fi

    # Check for wrong line format
    if [[ "${#args[@]}" -ne 3 ]]; then
	echoerr "$FILE: linea $LINE: Error de formato en linea de configuracion"
	exit -1
    fi

    # Configuration parameters
    DIR="${args[0]}"
    SERV="${args[1]}"
    CONFIG="${args[2]}"

    # Check if config file for that service exists
    if [[ ! -e "$CONFIG" ]]; then
	echoerr "$FILE: linea $LINE: El archivo '$CONFIG' no existe"
	exit -1
    fi





    LINE=$(($LINE + 1))
done < $FILE
# Length of the array --> ${#args[@]}
