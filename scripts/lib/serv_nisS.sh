#!/usr/bin/env bash
source lib/aux_functions.sh

nisServerFunc() {
    # Package management
    packageMng $2 "nis"
    if [[ $? -ne 0]]; then
    exit -1
    fi

    # Read the parameters of the service
    exec 3<> $3;
    read DOMAIN_NAME <&3; # Name of the NIS domain
    exec 3<&-;

    # Check if the argument exist
    if [[ $DOMAIN_NAME == ""]]; then
	echoWrongParams $1 $4 $3;
	exit 6;
    fi

    # Role configuration
    sshcmd $2 "echo NISSERVER=master > /etc/default/nis"
    if [[ $? -ne 0]]; then 
    echoerr "\n$1 linea $4: Error al configurar el rol del servidor, no se pudo escribir en el directorio /etc/default/nis"
    exit 40;
    fi

    # Store passwords on the NIS server too
    sshcmd $2 "sed -i 's/MERGE_PASSWD=false/MERGE_PASSWD=true/g' /var/yp/Makefile"
    if [[ $? -ne 0]]; then 
    echoerr "\n$1 linea $4: Error al configurar el fichero /var/yp/Makefile"
    exit 41;
    fi

    sshcmd $2 "sed -i 's/MERGE_GROUP=false/MERGE_GROUP=true/g' /var/yp/Makefile"
    if [[ $? -ne 0]]; then 
    echoerr "\n$1 linea $4: Error al configurar el fichero /var/yp/Makefile"
    exit 42;
    fi

    # Configure Domain
    sshcmd $2 "echo '$DOMAIN_NAME' >> /etc/defaultdomain"
    if [[ $? -ne 0]]; then 
    echoerr "\n$1 linea $4: Error al configurar /etc/defaultdomain"
    exit 43;
    fi

    # Start service
    sshcmd $2 "service nis restart"
    if [[ $? -ne 0]]; then 
    echoerr "\n$1 linea $4: Error al reiniciar el servicio NIS"
    exit 46;
    fi

    #Update NIS database
    sshcmd $2 "/usr/lib/yp/ypinit -m < /dev/null"
    if [[ $? -ne 0]]; then 
    echoerr "\n$1 linea $4: Error al configurar la base de datos de NIS"
    exit 45;
    fi

    # Start service
    sshcmd $2 "service nis restart"
    if [[ $? -ne 0]]; then 
    echoerr "\n$1 linea $4: Error al reiniciar el servicio NIS"
    exit 46;
    fi
}