#!/bin/bash
source "aux_functions.sh"

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

    # TODO: Add error checks of mdadm
    exit 0;
}
