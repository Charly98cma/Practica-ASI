#!/usr/bin/env bash
source lib/aux_functions.sh

nisServerFunc() {
    echo "      -> Instalando el paquete NIS";
    # Package management
    packageMng $2 "nisS";
    if [[ $? -ne 0 ]]; then
        exit -1
    fi

    echo "      -> Leyendo y comprobando fichero de configuracion";
    # Read the parameters of the service
    exec 3<> $3;
    read DOMAIN_NAME <&3; # Name of the NIS domain
    exec 3<&-;

    # Check if the argument exist
    if [[ $DOMAIN_NAME == "" ]]; then
        echoWrongParams $1 $4 $3;
        exit 6;
    fi

    echo "      -> Configurando el rol del servicio NIS en el fichero /etc/default/nis";
    # Role configuration
    sshcmd $2 "echo NISSERVER=master > /etc/default/nis";
    if [[ $? -ne 0 ]]; then
        echoerr "\n$1 linea $4: Error al configurar el rol del servidor, no se pudo escribir en el directorio /etc/default/nis";
        exit 40;
    fi

    echo "      -> Configurando la variable MERGE_PASSWD en el fichero /var/yp/Makefile";
    # Store passwords on the NIS server too
    sshcmd $2 "sed -i 's/MERGE_PASSWD=false/MERGE_PASSWD=true/g' /var/yp/Makefile";
    if [[ $? -ne 0 ]]; then 
    echoerr "\n$1 linea $4: Error al configurar el fichero /var/yp/Makefile";
    exit 41;
    fi

    echo "      -> Configurando la variable MERGE_GROUP en el fichero /var/yp/Makefile";
    sshcmd $2 "sed -i 's/MERGE_GROUP=false/MERGE_GROUP=true/g' /var/yp/Makefile";
    if [[ $? -ne 0 ]]; then 
    echoerr "\n$1 linea $4: Error al configurar el fichero /var/yp/Makefile";
    exit 42;
    fi

    echo "      -> Configurando el dominio del servicio en el fichero /etc/defaultdomain";
    # Configure Domain
    sshcmd $2 "echo '$DOMAIN_NAME' >> /etc/defaultdomain";
    if [[ $? -ne 0 ]]; then 
    echoerr "\n$1 linea $4: Error al configurar /etc/defaultdomain";
    exit 43;
    fi

    echo "      -> Reiniciando el servicio";
    # Start service
    sshcmd $2 "service nis restart";
    if [[ $? -ne 0 ]]; then 
    echoerr "\n$1 linea $4: Error al reiniciar el servicio NIS";
    exit 46;
    fi

    echo "      -> Actualizando la base de datos de NIS";
    #Update NIS database
    sshcmd $2 "/usr/lib/yp/ypinit -m < /dev/null";
    if [[ $? -ne 0 ]]; then
        echoerr "\n$1 linea $4: Error al configurar la base de datos de NIS";
        exit 45;
    fi

    echo "      -> Reiniciando el servicio";
    # Start service
    sshcmd $2 "service nis restart";
    if [[ $? -ne 0 ]]; then
        echoerr "\n$1 linea $4: Error al reiniciar el servicio NIS";
        exit 46;
    fi
}

export -f nisServerFunc
