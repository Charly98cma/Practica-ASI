#!/usr/bin/env bash
source lib/aux_functions.sh

# MOUNT
# Params:
#  $1 = $FILE
#  $2 = $DIR of the host
#  $3 = $CONFIG file
#  $4 = $LINE
# Return:
#  0          - Success
#  Error code - Otherwise
nfsClientFunc() {
    # Package management
    packageMng $2 "nfsC"
    if [[ $? -ne 0 ]]; then
	exit 255;
    fi

    # Iterate over directories to export
    while IFS= read -r line; do
	serverIP=$(echo $line | awk {'print $1'})
	exportedDir=$(echo $line | awk {'print $2'})
	mntPoint=$(echo $line | awk {'print $3'})

	# Check if all arguments exists
	if [[ $serverIP == "" || $exportedDir == "" || $mntPoint == "" ]]; then
	    echoWrongParams $1 $4 $3;
	    exit 6;
	fi

	# Check if host is valid
	eval ping -c 2 $serverIP > /dev/null
	if [[ $? -ne 0 ]]; then
	    echoerr "\n$1: linea $4: La dirección del host no es válida\n";
	    exit 70;
	fi

	# Check if the directory is actually exported
	eval showmount -e $serverIP | grep $exportedDir
	if [[ $? -ne 0 ]]; then
	    echoerr "\n$1: linea $4: El directorio $exportedDir no está exportado en el servidor $serverIP\n";
	    exit 71;
	fi

	# Check if mntPoint exists
	echo "      -> Comprobando si existe el punto de montaje..."
	sshcmd $2 "find \"$mntPoint\" -maxdepth 0";
	case $? in
	    255)
		# SSH Error
		echoerr "\n$1: linea $4: Se ha producido un error inesperado del servicio 'ssh'\n";
		exit 255;
		;;
	    0)
		# mntPoint dir exists, check if its empty (0 if non empty, 1 if empty)
		sshcmd $2 "ls -1qA \"$mntPoint\" | grep -q .";
		if [[ $? -eq 0 ]]; then
		    echoerr "\n$1: linea $4: Error al configurar el punto de montaje\nEl directorio '$mntPoint' en la máquina '$2' no es un directorio vacío\n";
		    exit 72;
		fi
		;;
	    *)
		# mntPoint dir doesnt exist, so we create it
		echo "      -> Creando el punto de montaje..."
		sshcmd $2 "mkdir -p \"$mntPoint\"";
		if [[ $? -ne 0 ]]; then
		    echoerr "\n$1: linea $4: Error inesperado al crear el directorio '$mntPoint' en el host '$2'\n";
		    exit 73;
		fi
		;;
	esac

	# Mount of the exported directory
	sshcmd $2 "mount -t nfs $serverIP:$exportedDir $mntPoint";
	if [[ $? -ne 0 ]]; then
	    echoerr "\n$1: linea $4: Error inesperado durante el montaje en '$mntPoint'\n";
	    exit 74;
	fi

	# Edit /etc/fstab file in order to make it persistent
	echo "      -> Editando el fichero /etc/fstab..."
	sshcmd $2 "\"echo \"$serverIP:$exportedDir $mntPoint nfs defaults 0 0\" >> /etc/fstab \""
	
    done < $3;
    exit 0;
}
export -f nfsClientFunc
