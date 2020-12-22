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
    packageMng $2 "backupC"
    if [[ $? -ne 0 ]]; then
	exit -1;
    fi

    # Read the parameters of the service
    exec 3<> $3;
    read BACKUP_SOURCE <&3; # Dir. to backup
    read DIR_SERVER <&3;    # Dir. of the host to store backups
    read BACKUP_DEST <&3;   # Dir. of the backup on the DIR_SERVER
    read FREQUENCY <&3;     # Freq. of the backup (hours)
    exec 3<&-;

    # Check all arguments appear on the file
    if [[ $BACKUP_SOURCE == "" || $DIR_SERVER == "" || $BACKUP_DEST == "" || $FREQUENCY == "" ]]; then
	echoWrongParams $1 $4 $3;
	exit 6;
    fi

    # Check the dir. to backup (BACKUP_SOURCE) exists
    sshcmd $2 "find $BACKUP_SOURCE -maxdepth 0";
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
	    echoerr "\n$1: linea $4: Error en la configuración del cliente de backup\nLa direccion '$BACKUP_SOURCE' en el host '$2' no existe\n";
	    exit 80;
	    ;;
    esac

    # Check the dir. used fto store the backups (BACKUP_DEST) exists
    sshcmd "$DIR_SERVER" "find $BACKUP_DEST -maxdepth 0";
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
	    echoerr "\n$1: linea $4: Error en la configuración del cliente de backup\nLa direccion '$BACKUP_DEST' en el host '$DIR_SERVER' no existe\n";
	    exit 81;
	    ;;
    esac

    # Check if the backup frequency is correct (greater than 0)
    if [ $((FREQ)) -ge 1 ]; then
	echoerr "\n$1: linea $4: Error en la configuración del cliente de backup\nLa frecuencia de los backup tiene que ser mayor de 0 horas\n";
	exit 82;
    fi

    sshcmd $2 "rsync --quiet --update --executability --owner --group --recursive $BACKUP_SOURCE practicas@$DIR_SERVER:$BACKUP_DEST"
    case $? in
	255)
	    # SSH Error
	    echoerr "\nERROR - Se ha producido un error inesperado del servicio 'ssh'\n";
	    exit 255;
	    :
	    ;;
	0)
	    exit 0;
	    ;;
	*)
	    # Error of the rsync
	    echoerr "\n$1: linea $4: Se ha producido un error inesperado al crear el cliente de backup.\n";
	    exit 83;
    esac

    sshcmd $2 "echo 0 */$FREQ * * * rsync --quiet --update --executability --owner --group --recursive $BACKUP_SOURCE practicas@$DIR_SERVER:$BACKUP_DEST >> /etc/crontab"
    case $? in
	255)
	    # SSH Error
	    echoerr "\nERROR - Se ha producido un error inesperado del servicio 'ssh'\n";
	    exit 255;
	    :
	    ;;
	0)
	    exit 0;
	    ;;
	*)
	    # Error introducng the command to /etc/crontab
	    echoerr "\n$1: linea $4: Se ha producido un error inesperado al introducir el comando de backup en el archivo /etc/crontab\n";
	    exit 84;
    esac
    exit 0;
}
