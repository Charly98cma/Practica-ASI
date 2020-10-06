#!/bin/bash

# Easy error printing function
echoerr() { echo "$@" 1>&2; }

# Argument check
if [[ "$#" -ne 1 ]]
then
    echoerr "Use: $0 fichero_configuracion"
    exit
fi

# File check
if [[ ! -e "$1" ]]
then
    echoerr "El archivo '$1' no existe."
    exit
fi

filename = "$1"
