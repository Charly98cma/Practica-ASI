#!/bin/bash

####################
# CUSTOM LIBRARIES #
####################

source "lib/aux_functions.sh"
source "lib/serv_mount.sh"
source "lib/serv_raid.sh"
source "lib/serv_lvm.sh"


#################
# MAIN FUNCTION #
#################

# Argument check
if [[ "$#" -ne 1 ]]; then
    echoerr "Use: $0 fichero_configuracion";
    exit 1;
fi

# Check if config file exists
if [[ ! -e "$1" ]]; then
    echoerr "ERROR - El archivo '$1' no existe";
    exit 2;
fi
if [[ ! -f "$1" ]]; then
    echoerr "ERROR - '$1' es un directorio y no un archivo";
    exit 2;
fi

# Name of the config file and line reading
FILE="$1";
LINE=1;

echo "=> Leyendo fichero de configuracion...";

# Reading loop
while read line; do
    # String --> Array of words
    IFS=" " read -a args <<< "$line";

    # Skip the line if it's a comment or an empty line
    if [[ "${args[0]}" == "#" || "${args[0]}" == "" ]]; then
	LINE=$(($LINE + 1));
	continue;
    fi

    # Check for wrong line format
    if [[ "${#args[@]}" -ne 3 ]]; then
	echoerr "$FILE: linea $LINE: Error de formato en linea de configuracion";
	exit 3;
    fi

    # Configuration parameters
    DIR="${args[0]}";
    SERV="${args[1]}";
    CONFIG="${args[2]}";

    # Message of service being executed
    echoConfig "$SERV" "$CONFIG";

    # Check if config file for that service exists
    if [[ ! -e "$CONFIG" ]]; then
	echoerr "$FILE: linea $LINE: El archivo '$CONFIG' no existe";
	exit 4;
    fi

    # Switch case of the service (diff services have diff behavior)
    case $SERV in
	# MOUNT service
	"mount")
	    RES=mountFunc "$FILE" "$DIR" "$CONFIG" "$LINE";
	    if [[ "$RES" -ne 0 ]]; then
		exit RES;
	    fi
	    unset RES;
	    echoDone;
	    ;;

	# RAID service
	"raid")
	    RES=raidFunc "$FILE" "$DIR" "$CONFIG" "$LINE";
	    if [[ "$RES" -ne 0 ]]; then
		exit RES;
	    fi
	    unset RES;
	    echoDone;
	    ;;


	"lvm")
	    RES=lvmFunc "$FILE" "$DIR" "$CONFIG" "$LINE";
	    if [[ "$RES" -ne 0 ]]; then
		exit RES;
	    fi
	    unset RES;
	    echoDone;
	    ;;

	"nis-server")
	    RES=nisServerFunc "$FILE" "$DIR" "$CONFIG" "$LINE";
	    if [[ "$RES" -ne 0 ]]; then
		exit RES;
	    fi
	    unset RES;
	    echoDone;
	    ;;

	"nis-client")
	    RES=nisClientFunc "$FILE" "$DIR" "$CONFIG" "$LINE";
	    if [[ "$RES" -ne 0 ]]; then
		exit RES;
	    fi
	    unset RES;
	    echoDone;
	    ;;

	"nfs_server")
	    RES=nfsServerFunc "$FILE" "$DIR" "$CONFIG" "$LINE";
	    if [[ "$RES" -ne 0 ]]; then
		exit RES;
	    fi
	    unset RES;
	    echoDone;
	    ;;

	"nfs_client")
	    RES=nfsClientFunc "$FILE" "$DIR" "$CONFIG" "$LINE";
	    if [[ "$RES" -ne 0 ]]; then
		exit RES;
	    fi
	    unset RES;
	    echoDone;
	    ;;

	"backup_server")
	    RES=backupServerFunc "$FILE" "$DIR" "$CONFIG" "$LINE";
	    if [[ "$RES" -ne 0 ]]; then
		exit RES;
	    fi
	    unset RES;
	    echoDone;
	    ;;

	"backup_client")
	    RES=backupClientFunc "$FILE" "$DIR" "$CONFIG" "$LINE";
	    if [[ "$RES" -ne 0 ]]; then
		exit RES;
	    fi
	    unset RES;
	    echoDone;
	    ;;

	*)
	    # Unknown service detected on the config file
	    echoerr "$FILE: linea $LINE: No se reconce el servicio '$SERV'"
	    exit 5
	    ;;
    esac
    LINE=$(($LINE + 1))
done < $FILE
