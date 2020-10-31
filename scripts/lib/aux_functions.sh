#!/bin/bash

######################
# AUXILIAR FUNCTIONS #
######################

# Messages management functions
echoerr() {
    echo "$1" 1>&2;
}
export -f echoerr

echoConfig() {
    echo "   -> Configurando servicio '$1' en '$2'";
}
export -f echoConfig

echoDone() {
    echo "      DONE";
}
export -f echoDone


# Assoaciates file (arg 2) to file descriptor (arg 1
assocDesc() {
    exec "$1<$2";
}
export -f assocDesc

# Free the descriptor (arg 1
freeDesc() {
    exec "$1<&-";
}
export -f freeDesc


# Method to easy execution of commands on other host through SSH
# REVIEW: Check if changes are required to run the different commands we will be handling
sshcmd() {
    # Connection to the SHH server and execution of commands
    # ssh USER@dir command1 | command2 ...
    eval "ssh practicas@$1 ${@:2}";
}
export -f sshcmd
