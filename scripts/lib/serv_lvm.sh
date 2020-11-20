#!/bin/bash
export "aux_functions.sh"

# LVM
# Params:
#  $1 = $FILE
#  $2 = $DIR of the host
#  $3 = $CONFIG file
#  $4 = $LINE
# Returns:
#  0          - Success
#  Error code - Otherwise
lvmFunc() {

    assocDesc "3" "$3";
    read NAME <&3;
    read DEVS <&3;
    read line <&3;

    if [[ "$NAME" == "" || "$DEVS" == "" || "$line" == "" ]]; then
	echoWrongParams "$1" "$4" "$3";
	exit 6;
    fi

    IFS=" " read -a DEVS_ARR <<< "$DEVS";

    # Check that each of the dirs/devices exists on the host
    for DEV in "${DEVS_ARR[@]}"; do
	sshcmd "$2" "find $DEV -maxdepth 0";
	if [[ "$?" -ne 0 ]]; then
	    echoerr "$1: linea $4: Error en el dispositivo a montar";
	    echoerr "El dispositivo '$DEV' en la máquina '$2' no existe."
	    exit 8;
	fi
    done;

    # Creation of the devices group
    sshcmd "$2" "vgcreate $NAME $DEVS";
    if [[ "$?" -ne 0 ]]; then
	echoerr "$1: Error inesperado al crear el grupo '$NAME'.";
	exit 14;
    fi

    while read line; do
	echo;
    done <&3;


}
