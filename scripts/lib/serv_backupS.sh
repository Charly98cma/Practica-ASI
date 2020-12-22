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
backupServerFunc() {
    # Read the parameters of the service
    exec 3<> $3;
    read BACKUP_DEST <&3;
    exec 3<&-;

    # Check all parameters exist
    if [[ $BACKUP_DEST == "" ]]; then
	echoWrongParams $1 $4 $3;
	exit 6;
    fi

    sshcmd $2 "find $BACKUP_DEST -maxdepth 0";
    case $? in
	255)
	    # SSH Error
	    echoerr "\nERROR - Se ha producido un error inesperado del servicio 'ssh'\n";
	    exit 255;
	    :
	    ;;

	0)
	    : # The BACKUP_SOURCE exists => no error
	    ;;

	*)
	    # The BACKUP_SOURCE dir doesnt exist
	    echoerr "\n$1: linea $4: Error en la configuración del servidor de backup\nLa direccion '$BACKUP_DEST' en el host '$2' no existe\n";
	    exit 90;
	    ;;
    esac


    # BACKUP_DEST  exists, check if its empty (0 if non empty, 1 if empty)
    sshcmd $2 "ls -1qA $BACKUP_DEST | grep -q .";
    if [[ $? -eq 0 ]]; then
	echoerr "\n$1: linea $4: Error al configurar el servidor de backup\nEl directorio '$BACKUP_DEST' en la máquina '$2' no es un directorio vacío\n";
	exit 91;
    fi

    exit 0;
}

export -f backupServerFunc
