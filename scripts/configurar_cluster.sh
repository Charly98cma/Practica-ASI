#!/usr/bin/env bash

####################
# CUSTOM LIBRARIES #
####################

source lib/aux_functions.sh
source lib/serv_mount.sh
source lib/serv_raid.sh
source lib/serv_lvm.sh
# source lib/serv_nisC.sh
# source lib/serv_nisS.sh
# source lib/serv_nfsC.sh
source lib/serv_nfsS.sh
# source lib/serv_backupC.sh
# source lib/serv_backupS.sh

#################
# MAIN FUNCTION #
#################

# Argument check
if [[ $# -ne 1 ]]; then
    echoerr "Use: $0 fichero_configuracion";
    exit 1;
fi

# Check if the config file exists
if [[ ! -e $1 ]]; then
    echoerr "ERROR - El archivo '$1' no existe";
    exit 2;
fi
# Check if the config file is a file
if [[ ! -f $1 ]]; then
    echoerr "ERROR - '$1' es un directorio y no un archivo";
    exit 2;
fi

# Name of the config file and line reading
FILE=$1;
NUMLINE=1;

echo "=> Leyendo fichero de configuracion...";

# Reading loop
while read line; do

    # String --> Array of words
    IFS=" " read -a args <<< $line;

    # Skip the line if it's a comment or an empty line
    if [[ ${args[0]} == "#" || ${args[0]} == "" ]]; then
	NUMLINE=$(($NUMLINE + 1));
	continue;
    fi

    # Check for wrong line format
    if [[ ${#args[@]} -ne 3 ]]; then
	echoerr "$FILE: linea $NUMLINE: Error de formato en linea de configuracion";
	exit 3;
    fi

    # Configuration parameters
    DIR=${args[0]};
    SERV=${args[1]};
    CONFIG=${args[2]};

    # Message of service being executed
    echoConfig $SERV $DIR;

    # Check if config file for that service exists
    if [[ ! -e $CONFIG ]]; then
	echoerr "$FILE: linea $NUMLINE: El archivo '$CONFIG' no existe";
	exit 4;
    fi

    # Switch case of the service (diff services have diff behavior)
    case $SERV in
	mount)
	    mountFunc $FILE $DIR $CONFIG $NUMLINE; ;;

	raid)
	    raidFunc $FILE $DIR $CONFIG $NUMLINE; ;;

	lvm)
	    lvmFunc $FILE $DIR $CONFIG $NUMLINE; ;;

	nis-server)
	    nisServerFunc $FILE $DIR $CONFIG $NUMLINE; ;;

	nis-client)
	    nisClientFunc $FILE $DIR $CONFIG $NUMLINE; ;;

	nfs_server)
	    nfsServerFunc $FILE $DIR $CONFIG $NUMLINE; ;;

	nfs_client)
	    nfsClientFunc $FILE $DIR $CONFIG $NUMLINE; ;;

	backup_server)
	    backupServerFunc $FILE $DIR $CONFIG $NUMLINE; ;;

	backup_client)
	    backupClientFunc $FILE $DIR $CONFIG $NUMLINE; ;;

	*)
	    # Unknown service detected on the config file
	    echoerr "$FILE: linea $NUMLINE: No se reconce el servicio '$SERV'"
	    exit 5
	    ;;
    esac
    echoDone;
    NUMLINE=$(($NUMLINE + 1))
done < $FILE
exit 0;
