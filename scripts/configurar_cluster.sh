#!/bin/bash


######################
# AUXILIAR FUNCTIONS #
######################

# Easy error printing function
echoerr() { echo "$1" 1>&2; }

echoConfig() { echo "   -> Configurando servicio '$1' en '$2'"; }
echoDone() { echo "      DONE"; }


# Assoaciates file (arg 2) to file descriptor (arg 1
assocDesc() { exec "$1<$2"; }
# Free the descriptor (arg 1
freeDesc() { exec "$1<&-"; }


# Method to easy execution of commands on other host through SSH
# REVIEW: Check if changes are required to run the different commands we will be handling
sshcmd() {
    # Connection to the SHH server and execution of commands
    # ssh USER@dir command1 | command2 ...
    eval "ssh practicas@$1 ${@:2}";
}


#############################
# FUNCTIONS OF EACH SERVICE #
#############################

# MOUNT
# Params:
#  $1 = $FILE
#  $2 = $DIR of the host
#  $3 = $CONFIG file
#  $4 = $LINE
# Return:
#  0         - Success
#  Otherwise - Error
mountFunc() {
    # Read DEVICE and mount POINT using the file descriptor 3 temporarly
    assocDesc "3" "$3";
    read DEVICE <&3;
    read POINT  <&3;
    freeDesc "3";

    # Check if both lines exist
    if [[ "$DEVICE" == "" || "$POINT" == "" ]]; then
	echoerr "$1: linea $4: Error en el formato del archivo de configuración '$3'";
	exit 6;
    fi

    # Check if POINT exists
    sshcmd "$2" "find $POINT -maxdepth 0";

    if [[ "$?" -ne 0 ]]; then
	# POINT dir doesnt exist, we create it
	# REVIEW: See if's necessary to check for error on the mkdir
	sshcmd "$2" "mkdir $POINT";
    else
	# POINT dir exists, check if its empty
	sshcmd "$2" "ls -A $POINT";
	if [[ "$?" -ne 1 ]]; then
	    echoerr "$1: linea $4: Error al configurar el punto de montaje";
	    echoerr "El directorio '$POINT' en la máquina '$2' no es un directorio vacío";
	    exit 7;
	fi
    fi

    # Mount of the device
    sshcmd "$2" "mount -t ext4 $DEVICE $POINT";
    if [[ "$1" -ne 0 ]]; then
	echoerr "$1: Error inesperado durante el montaje de '$DEVICE' en '$POINT'";
	exit 8;
    fi
    # Auto-mount on start-up ("default 0 0" are options for the mounts, which are irrelevant now)
    sshcmd "$2" "echo \"$DEVICE $POINT ext4 defaults 0 0\" >> /etc/fstab";
    if [[ "$1" -ne 0 ]]; then
	echoerr "$1: Error inesperado durante el montaje de '$DEVICE' en '$POINT'";
	exit 8;
    fi

    exit 0;
}


# RAID
# Params:
#  $1 = $FILE
#  $2 = $DIR of the host
#  $3 = $CONFIG file
#  $4 = $LINE
# Returns:
#  0         - Success
#  Otherwise - Error code
raidFunc() {
    # Read parameters (lines) of the config file
    assocDesc "3" "$3";
    read RAID_DEV <&3;
    read LEVEL <&3;
    read DEVICES <&3; # List of devices -> dev1 dev2 ...
    freeDesc "3";

    # Check if some of the required information is missing
    if [[ "$RAID_DEV" == "" || "$LEVEL" == "" || "$DEVICES" == "" ]]; then
	echoerr "$1: linea $4: Error en el formato del archivo de configuración '$3'";
	exit 6;
    fi

    # dev1 dev2 dev3 ... --> {dev1, dev2, dev3, ...}
    IFS=" " read -a DEVICE_ARR <<< "$DEVICES";

    # Raid creation command through ssh
    sshcmd "$2" "mdadm --create $RAID_DEV $DEVICES --level=$LEVEL --raid-devices=${DEVICE_ARR[@]}";

    exit 0;
}





#################
# MAIN FUNCTION #
#################

# Argument check
if [[ "$#" -ne 1 ]]; then
    echoerr "Use: $0 fichero_configuracion";
    exit 1;
fi

# Check if config file exists
if [[ ! -e "$@" ]]; then
    echoerr "ERROR - El archivo '$1' no existe";
    exit 2;
fi
if [[ ! -f "$@" ]]; then
    echoerr "ERROR - '$1' es un directorio y no un archivo";
    exit 2;
fi

# Name of the config file
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
	    ;;

	*)
	    # Unknown service detected on the config file
	    echoerr "$FILE: linea $LINE: No se reconce el servicio '$SERV'"
	    exit 5
	    ;;
    esac
    LINE=$(($LINE + 1))
done < $FILE
