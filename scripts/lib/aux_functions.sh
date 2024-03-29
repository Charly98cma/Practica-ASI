#!/usr/bin/env bash

############
# MESSAGES #
############


# Easy error printing function
# Params:
#  $1 -> Message to show
echoerr() {
    echo -e "$1" 1>&2;
}


# Message through the stderr (using 'echoerr') because the expected
# parameters on the service config. file ($3), which is specified on
# the config. file ($1) line ($2) aren't correct.
# Params:
#  $1 -> Config. file
#  $2 -> Line on the config. file
#  $3 -> Service config. file
echoWrongParams() {
    echoerr "\n$1: linea $2: Error en el formato del archivo de configuración '$3'\n";
}


# Message showing the service being configured
# Params:
#  $1 -> Name of the service
#  $2 -> Host being configured
echoConfig() {
    echo "   -> Configurando servicio '$1' en '$2'";
}


# Message showing a service has been configured properly
echoDone() {
    echo "      DONE";
}


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

    eval "ssh -n -o \"StrictHostKeyChecking=no\" root@$1 ${@:2} &> /dev/null";

    # Command for testing purposes ONLY
    # eval "ssh -n -o \"StrictHostKeyChecking=no\" root@$1 ${@:2}";
}


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
    case $2 in
	raid)
	    PKG="mdadm";
	    ;;
	lvm)
	    PKG="lvm2*";
	    ;;
	nisC)
	    PKG="nis";
	    ;;
	nisS)
	    PKG="nis";
	    ;;
	nfsC)
	    PKG="nfs-common"
	    ;;
	nfsS)
	    PKG="nfs-kernel-server":
	    ;;
	backupC|backupS)
	    PKG="rsync";
	    ;;
    esac

    # If the packet isn't installed, send the command to install it
    echo "      -> Instalando paquete '$PKG' del servicio '$2'";
    sshcmd $1 "apt-get --assume-yes install $PKG";
    if [[ $? -ne 0 ]]; then
	echoerr "\nERROR - Error inesperado al intentar instalar el/los paquete/s '$PKG' en el host '$1'\n";
	return 1;
    fi
    return 0;
}
