#!/bin/bash

############
# MESSAGES #
############


# Easy error printing function
# Params:
#  $1 -> Message to show
echoerr() {
    echo "$1" 1>&2;
}
export -f echoerr


# Message through the stderr (using 'echoerr') because the expected
# parameters on the service config. file ($3), which is specified on
# the config. file ($1) line ($2) aren't correct.
# Params:
#  $1 -> Config. file
#  $2 -> Line on the config. file
#  $3 -> Service config. file
echoWrongParams() {
    echoerr "$1: linea $2: Error en el formato del archivo de configuración '$3'";
}
export -f echoWrongParams


# Message showing the service being configured
# Params:
#  $1 -> Name of the service
#  $2 -> Host being configured
echoConfig() {
    echo "   -> Configurando servicio '$1' en '$2'";
}
export -f echoConfig

# Message showing a service has been configured properly
echoDone() {
    echo "      DONE";
}
export -f echoDone


###############
# DESCRIPTORS #
###############

# Assoaciates file (arg 2) to file descriptor (arg 1
# Params:
#  $1 -> File descriptor
#  $2 -> Free descriptor (number)
assocDesc() {
    exec "$1<$2";
}
export -f assocDesc


# Free the descriptor (arg 1)
# Params:
#  $1 -> File descriptor
freeDesc() {
    exec "$1<&-";
}
export -f freeDesc


###############
# SSH COMMAND #
###############

# Method to execute commands on the host through SSH
# REVIEW: Check if changes are required to run the different commands we will be handling
# Params:
#  $1 -> Dir of the host (IP or name)
#  ${@:2} -> Command to be executed on the host
sshcmd() {
    # Connection to the SHH server and execution of commands
    # ssh USER@dir command1 | command2 ...
    eval "ssh practicas@$1 ${@:2}";
}
export -f sshcmd


##################
# PACKET MANAGER #
##################

# Method that check if the required package is installed and,
# if it isn't, installs it.
# Params:
#  $1 -> Dir of the host (IP or name)
#  $2 -> Service
packageMng() {
    # Read the service and find out the package that must be installed
    case "$2" in
	"raid")
	    PKG="mdadm";
	    ;;

	*)  exit;
	    ;;
    esac

    # Check if that package ins installed
    sshcmd "$1" "dpkg -l $PKG";
    if [[ "$?" -ne 0 ]]; then
	# If the oacket isn't installed, send the command to install it
	sshcmd "$1" "sudo apt install $PKG";
	if [[ "$?" -ne 0 ]]; then
	    echoerr "Error inesperado al intentar instalar el paquete '$PKG' en el host '$1'"
	    exit -1;
	fi
    fi

    exit 0;
}
