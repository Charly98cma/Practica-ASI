#!/bin/bash
source "aux_functions.sh"

# Raid leveks allowed
RAID_LEVELS=("0" "1" "4" "5");

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
    # Read parameters (lines) of the config file
    assocDesc "3" "$3";
    read RAID_DEV <&3;
    read LEVEL <&3;
    read DEVICES <&3; # List of devices -> dev1 dev2 ...
    freeDesc "3";

    # Check if some of the required information is missing
    if [[ "$RAID_DEV" == "" || "$LEVEL" == "" || "$DEVICES" == "" ]]; then
	echoWrongParams "$1" "$4" "$3";
	exit 6;
    fi

    # TODO: Add RAID checks for non-supported LEVELs

    # dev1 dev2 dev3 ... --> {dev1, dev2, dev3, ...}
    IFS=" " read -a DEVICE_ARR <<< "$DEVICES";

    # Raid creation command through ssh
    sshcmd "$2" "mdadm --create $RAID_DEV $DEVICES --level=$LEVEL --raid-devices=${DEVICE_ARR[@]}";
    if [[ "$?" -eq 255 ]]; then
	echoerr "ERROR - Se ha producido un error inesperado en el servicio 'ssh'";
	exit 7;
    fi
    if [[ "$?" -ne 0 ]]; then
	echoerr "$1: linea $4: Error al configurar el servicio 'raid'";
	exit 12;
    fi

    exit 0;
}
