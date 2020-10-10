#!/bin/bash

# Easy error printing function
echoerr() { echo "$@" 1>&2; }

# Method to easy execution of commands on other host through SSH
# REVIEW: Check if changes are required to run the different commands we will be handling
sshcmd() {
    # Connection to the SHH server and execution of commands
    # ssh USER@dir command1 | command2 ...
    eval "ssh practicas@$1 ${@:2}"
}


# Argument check
if [[ "$#" -ne 1 ]]; then
    echoerr "Use: $0 fichero_configuracion"
    exit 1
fi

# Check if config file exists
# TODO: See if it's required to test also if it's a file or a dir
if [[ ! -e "$@" ]]; then
    echoerr "El archivo '$1' no existe"
    exit 2
fi

# Name of the config file
FILE="$1"
LINE=1

echo "Leyendo fichero de configuracion..."

# Reading loop
while read line; do
    # String --> Array of words
    IFS=" " read -a args <<< "$line"

    # Skip the line if it's a comment or an empty line
    if [[ "${args[0]}" == "#" || "${args[0]}" == "" ]]; then
	LINE=$(($LINE + 1))
	continue;
    fi

    # Check for wrong line format
    if [[ "${#args[@]}" -ne 3 ]]; then
	echoerr "$FILE: linea $LINE: Error de formato en linea de configuracion"
	exit 3
    fi

    # Configuration parameters
    DIR="${args[0]}"
    SERV="${args[1]}"
    CONFIG="${args[2]}"

    # Check if config file for that service exists
    if [[ ! -e "$CONFIG" ]]; then
	echoerr "$FILE: linea $LINE: El archivo '$CONFIG' no existe"
	exit 4
    fi

    # Switch case of the service (diff services have diff behavior)
    case $SERV in
	"mount")
	    # Read DEVICE and mount POINT
	    read DEVICE;
	    read POINT;
	    # Check  if POINT exists
	    sshcmd "$DIR find --maxdepth 0 $POINT"
	    if [[ "$?" -ne 0 ]]; then
		# POINT dir doesnt exist, we create it
		sshcmd "$DIR mkdir $POINT"
	    else
		# POINT dir exists, check if its empty
		sshcmd "$DIR ls -A $POINT"
		if [[ "$?" -ne 1 ]]; then
		    echoerr "$FILE: linea $LINE: Error al configurar el punto de montaje"
		    echoerr "El directorio '$POINT' en la máquina '$DIR' no es un directorio vacío"
		    exit 6
		fi
	    fi

	    # TODO: Check the next two cmd results (in case of unexpected error)
	    # Mount of the device
	    sshcmd "$DIR mount -t ext4 $DEVICE $POINT"
	    # Auto-mount on start-up ("default 0 0" are options for the mounts, which are irrelevant now)
	    sshcmd "$DIR echo \"$DEVICE $POINT ext4 defaults 0 0\" >> /etc/fstab"
	    ;;
	*)
	    # Unknown service detected on the config file
	    echoerr "$FILE: linea $LINE: No se reconce el servicio '$SERV'"
	    exit 5
	    ;;
    esac







    LINE=$(($LINE + 1))
done < $FILE
# Length of the array --> ${#args[@]}
