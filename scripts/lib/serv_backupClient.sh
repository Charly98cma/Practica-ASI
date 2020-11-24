#!/usr/bin/env bash
source lib/aux_functions.sh

# BACKUP CLIENT
# Params:
#  $1 = $FILE
#  $2 = $DIR of the host
#  $3 = $CONFIG file
#  $4 = $LINE
# Return:
#  0          - Success
#  Error code - Otherwise
backupClientFunc() {
    # Package management
    packageMng "$2" "lvm"
    if [[ "$?" -ne 0 ]]; then
	exit -1;
    fi

    # Read the parameters of the service
    assocDesc "3" "$3";
    read BACKUP_SOURCE <&3;
    read DIR_SERVER <&3;
    read BACKUP_DEST <&3;
    read FREQUENCY <&3;
    freeDesc "3";

    if [[ "$BACKUP_SOURCE" == "" || "$DIR_SERVER" == "" || "$BACKUP_DEST" == "" || "$FREQUENCY" == "" ]]; then
	echoWrongParams "$1" "$4" "$3";
	exit 6;
    fi

    exit 0;
}
