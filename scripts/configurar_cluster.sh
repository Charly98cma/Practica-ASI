#!/bin/bash

# Easy error printing function
echoerr() { echo "$@" 1>&2; }

# Argument check
if [[ "$#" -ne 1 ]]; then
    echoerr "Use: $0 fichero_configuracion"
    exit -1
fi

# File check
if [[ ! -e "$1" ]]; then
    echoerr "El archivo '$1' no existe."
    exit -1
fi

# Name of the config file
FILE="$1"
LINE=1
while read line; do
    # String --> Array of words
    IFS=" " read -ra args <<< "$line"

    # Skip the line if it's a comment
    if [[ "${args[0]}" == "#" ]]; then
	continue;
    fi

    # Check for wrong line format
    if [[ "${#args[@]}" -ne 3 ]]; then
	echoerr "$0: línea $LINE: Error de formato en linea de configuracion"
	exit -1
    fi

    DIR="${args[0]}"
    SERV="${args[1]}"
    CONFIG="${args[2]}"


    LINE=$(($LINE + 1))
done < $FILE
# Length of the array --> ${#args[@]}
