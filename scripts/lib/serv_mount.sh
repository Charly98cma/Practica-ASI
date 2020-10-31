#!/bin/bash
export "aux_functions.sh"

# MOUNT
# Params:
#  $1 = $FILE
#  $2 = $DIR of the host
#  $3 = $CONFIG file
#  $4 = $LINE
# Return:
#  0          - Success
#  Error code - Otherwise
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

    # Checl if DEVICE exists
    sshcmd "$2" "find $DEVICE -maxdepth 0";
    if [[ "$?" -ne 0 ]]; then
	echoerr "$1: linea $4: Error en el dispositivo a montar";
	echoerr "El dispositivo '$DEVICE' en la máquina '$2' no existe."
	exit 8;
    fi

    # Check if POINT exists
    sshcmd "$2" "find $POINT -maxdepth 0";
    if [[ "$?" -ne 0 ]]; then
	# POINT dir doesnt exist, we create it
	# TODO: See if's necessary to check for error on the mkdir
	sshcmd "$2" "mkdir $POINT";
    else
	# POINT dir exists, check if its empty
	sshcmd "$2" "ls -A $POINT";
	if [[ "$?" -ne 1 ]]; then
	    echoerr "$1: linea $4: Error al configurar el punto de montaje";
	    echoerr "El directorio '$POINT' en la máquina '$2' no es un directorio vacío";
	    exit 9;
	fi
    fi

    # Mount of the device
    sshcmd "$2" "mount -t ext4 $DEVICE $POINT";
    if [[ "$1" -ne 0 ]]; then
	echoerr "$1: Error inesperado durante el montaje de '$DEVICE' en '$POINT'";
	exit 10;
    fi

    # Auto-mount on start-up ("default 0 0" are options for the mounts, which are irrelevant now)
    sshcmd "$2" "echo \"$DEVICE $POINT ext4 defaults 0 0\" >> /etc/fstab";
    if [[ "$1" -ne 0 ]]; then
	echoerr "$1: Error inesperado durante el montaje de '$DEVICE' en '$POINT'";
	exit 10;
    fi

    exit 0;
}
