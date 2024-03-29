#!/usr/bin/env bash
source lib/aux_functions.sh

# RAID
# Params:
#  $1 = $FILE
#  $2 = $DIR of the host
#  $3 = $CONFIG file
#  $4 = $LINE
# Returns:
#  0          - Success
#  Error code - Otherwise
raidFunc() {
    # Package management
    packageMng $2 "raid";
    if [[ $? -ne 0 ]]; then
	exit -1;
    fi

    echo "      -> Leyendo y comprobando fichero de configuración";
    # Read parameters (lines) of the config file
    exec 3<> $3;
    read RAID_DEV <&3;
    read LEVEL <&3;
    read DEVICES <&3; # List of devices -> dev1 dev2 ...
    exec 3<&-;

    # Check if some of the required information is missing
    if [[ $RAID_DEV == "" || $LEVEL == "" || $DEVICES == "" ]]; then
	echoWrongParams "$1" "$4" "$3";
	exit 6;
    fi


    echo "      -> Comprobando nivel de RAID";
    # Check for non-supported RAID level
    case $LEVEL in
	0|1|5|6|10)
	    : # Correct RAID level
	    ;;
	*)
	    echoerr "\n$1: linea $4: Error al configurar el servicio 'raid'\nEl nivel RAID '$LEVEL' no esta soportado\n";
	    exit 21;
	    ;;
    esac

    # dev1 dev2 dev3 ... --> {dev1, dev2, dev3, ...}
    IFS=" " read -a DEVICE_ARR <<< $DEVICES;


    echo "      -> Comprobando validez de cada dispositivo";
    for (( i=0; i<${#DEVICE_ARR[@]}; i++ )); do
	RES=sshcmd $2 "df -Th | grep \"^${DEVICE_ARR[i]}\"";
	if [[ $RES -eq 0 ]]; then
	    echoerr "\n$1: linea $4: El dispositivo '${DEVICE_ARR[i]}' en la máquina '$2' ya tiene un sistema de ficheros\n";
	    exit 22;
	fi
    done


    echo "      -> Creando RAID";
    # Raid creation command through ssh
    sshcmd $2 "mdadm --create --level=$LEVEL --raid-devices=${#DEVICE_ARR[@]} $RAID_DEV $DEVICES";
    case $? in
	255)
	    echoerr "\nERROR - Se ha producido un error inesperado en el servicio 'ssh'\n";
	    exit 7;
	    ;;

	0)  # If the return value is 0, then the operation was successful
	    exit 0;
	    ;;

	*)
	    echoerr "\n$1: linea $4: Error inesperado al configurar el servicio 'raid'\n";
	    exit 20;
	    ;;
    esac
}

export -f raidFunc
