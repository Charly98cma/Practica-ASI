#!/usr/bin/env bash
source lib/aux_functions.sh

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
    exec 3<> $3;
    read DEVICE <&3;
    read POINT  <&3;
    exec 3<&-;

    # Check if both lines exist
    if [[ "$DEVICE" == "" || "$POINT" == "" ]]; then
	echoWrongParams "$1" "$4" "$3";
	exit 6;
    fi

    # Check if DEVICE exists
    sshcmd "$2" "find $DEVICE -maxdepth 0";
    if [[ "$?" -ne 0 ]]; then
	echoerr "
		$1: linea $4: Error en el dispositivo a montar
		El dispositivo '$DEVICE' en la máquina '$2' no existe.
		";
	exit 10;
    fi

    # Check if POINT exists
    sshcmd "$2" "find $POINT -maxdepth 0";
    case $? in
	255)
	    # SSH Error
	    echoerr "
		    ERROR - Se ha producido un error inesperado del servicio 'ssh'
		    ";
	    exit 255;
	    ;;
	0)
	    # POINT dir exists, check if its empty
	    sshcmd "$2" "ls -A $POINT";
	    if [[ "$?" -ne 1 ]]; then
		echoerr "
			$1: linea $4: Error al configurar el punto de montaje
			El directorio '$POINT' en la máquina '$2' no es un directorio vacío
			";
		exit 11;
	    fi
	    ;;
	*)
	    # POINT dir doesnt exist, so we create it
	    sshcmd "$2" "mkdir $POINT";
	    if [[ "$?" -ne 0 ]]; then
		echoerr "
			$1: linea $4: Error inesperado al crear el directorio '$POINT' en el host '$2'
			";
		exit 13;
	    fi
	    ;;
    esac

    # Mount of the device
    sshcmd "$2" "mount -t ext4 $DEVICE $POINT";
    if [[ "$?" -ne 0 ]]; then
	echoerr "
		$1: linea $4: Error inesperado durante el montaje de '$DEVICE' en '$POINT'
		";
	exit 12;
    fi

    # Auto-mount on start-up ("default 0 0" are options for the mounts, which are irrelevant now)
    sshcmd "$2" "echo \"$DEVICE $POINT ext4 defaults 0 0\" >> /etc/fstab";
    if [[ "$?" -ne 0 ]]; then
	echoerr "
		$1: linea $4: Error inesperado durante el montaje de '$DEVICE' en '$POINT'
		";
	exit 12;
    fi

    exit 0;
}
export -f mountFunc
