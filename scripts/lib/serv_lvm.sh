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
	freeDesc "3";
	exit 6;
    fi

    IFS=" " read -a DEVS_ARR <<< "$DEVS";

    # Check that each of the dirs/devices exists on the host
    for DEV in "${DEVS_ARR[@]}"; do
	sshcmd "$2" "find $DEV -maxdepth 0";
	if [[ "$?" -ne 0 ]]; then
	    echoerr "$1: linea $4: El dispositivo '$DEV' en la máquina '$2' no existe.";
	    freeDesc "3";
	    exit 8;
	fi
    done;

    # Initialization of the physical volumes
    sshcmd "$2" "pvcreate $DEVS"
    if [[ "$?" -ne 0 ]]; then
	echoerr "$1: linea $4: Error al inicializar los volúmenes físicos"
	freeDesc "3";
	exit 14;
    fi

    # Creation of the devices group
    sshcmd "$2" "vgcreate $NAME $DEVS";
    if [[ "$?" -ne 0 ]]; then
	echoerr "$1: linea $4: Error inesperado al crear el grupo '$NAME' de volumenes fisicos";
	freeDesc "3";
	exit 15;
    fi

    I=1;
    # Creation of each logical volume
    while read line; do
	# Check if there are more logical volumes that physical volumes on the group
	if [[ $((I)) -gt ${#DEVS_ARR[@]} ]]; then
	    echoerr "$1: linea $4: Se ha excedido el tamaño del grupo al crear los volúmenes lógicos";
	    freeDesc "3";
	    exit 16;
	fi

	# Read name and size of the logical volume
	IFS=" " read -a LINE <<< "$line";

	# Creation of the logical volume
	sshcmd "$3" "lvcreate --name $LINE[0] --size $LINE[1] $NAME";
	if [[ "$?" -ne 0 ]]; then
	    echoerr "$1: linea $4: Error inesperado al crear el volúmen lógico '$LINE[0]'"
	    freeDesc "3";
	    exit 17;
	fi
	I=$((I+1));
    done <&3;

    freeDesc "3";
    exit 0;
}
