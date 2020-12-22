#!/usr/bin/env bash
source lib/aux_functions.sh

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
    # Package management
    packageMng $2 "lvm"
    if [[ $? -ne 0 ]]; then
	exit 255;
    fi

    echo "      -> Leyendo y comprobando fichero de configuración";
    # Read the parameters of the service
    exec 3<> $3;
    read NAME <&3;
    read DEVS <&3;

    # Check all parameters exist
    if [[ $NAME == "" || $DEVS == "" ]]; then
	echoWrongParams $1 $4 $3;
	exec 3<&-;
	exit 6;
    fi

    # Turn the DEVS string to an array
    IFS=" " read -a DEVS_ARR <<< $DEVS;

    echo "      -> Comprobando validez de cada dispositivo";
    # Check that each of the dirs/devices exists on the host
    for DEV in ${DEVS_ARR[@]}; do
	sshcmd $2 "find $DEV -maxdepth 0";
	if [[ $? -ne 0 ]]; then
	    echoerr "\n$1: linea $4: El dispositivo '$DEV' en la máquina '$2' no existe\n";
	    exec 3<&-;
	    exit 30;
	fi
    done;

    echo "      -> Inicializando volúmenes físicos";
    # Initialization of the physical volumes
    sshcmd $2 "pvcreate $DEVS"
    if [[ $? -ne 0 ]]; then
	echoerr "\n$1: linea $4: Error inesperado inicializar los volúmenes físicos\n";
	exec 3<&-;
	exit 31;
    fi


    echo "      -> Inicializando grupo de dispositivos";
    # Creation of the devices group
    sshcmd $2 "vgcreate $NAME $DEVS";
    if [[ $? -ne 0 ]]; then
	echoerr "\n$1: linea $4: Error inesperado al crear el grupo '$NAME' de volumenes fisicos\n";
	exec 3<&-;
	exit 32;
    fi

    echo "      -> Creando volúmenes lógicos";
    I=1;
    # Creation of each logical volume
    while read line; do
	# Check if there are more logical volumes that physical volumes on the group
	if [[ $((I)) -gt ${#DEVS_ARR[@]} ]]; then
	    echoerr "\n$1: linea $4: Se ha excedido el tamaño del grupo al crear los volúmenes lógicos\n";
	    exec 3<&-;
	    exit 33;
	fi

	# Read name and size of the logical volume
	IFS=" " read -a LINE <<< $line;

	echo "       -> Creando volúmen lógico '${LINE[0]}'";
	# Creation of the logical volume
	sshcmd $2 "lvcreate --name ${LINE[0]} --size ${LINE[1]} $NAME";
	if [[ $? -ne 0 ]]; then
	    echoerr "\n$1: linea $4: Error inesperado al crear el volúmen lógico '${LINE[0]}' de tamaño '${LINE[1]}'\n";
	    exec 3<&-;
	    exit 34;
	fi

	I=$((I+1));
    done <&3;

    # Check if at least one line is read on the logical volume creation loop
    if [[ $((I)) -eq 1 ]]; then
	echoWrongParams $1 $4 $3;
	exec 3<&-;
	exit 6;
    fi

    exec 3<&-;
    exit 0;
}

export -f lvmFunc
