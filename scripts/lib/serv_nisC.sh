#!/usr/bin/env bash
source lib/aux_functions.sh

nisClientFunc() {
    echo "      -> Instalando el paquete NIS";
    # Package management
    packageMng $2 "nis";
    if [[ $? -ne 0 ]]; then
        exit -1;
    fi

    echo "      -> Leyendo y comprobando ficheros de configuracion"
    # Read the parameters of the service
    exec 3<> $3;
    read DOMAIN_NAME <&3; # Name of the NIS domain
    read SERVER_ADDR <&3; # Adress of the NIS SERVER
    exec 3<&-;

    # Check if the argument exist
    if [[ $DOMAIN_NAME == "" || $SERVER_ADDR == "" ]]; then
        echoWrongParams $1 $4 $3;
        exit 6;
    fi

    echo "      -> Configurando el rol del servicio NIS en el fichero /etc/default/nis"
    # Role configuration
    sshcmd $2 "echo NISCLIENT=true > /etc/default/nis";
    if [[ $? -ne 0 ]]; then
        echoerr "\n$1 linea $4: Error al configurar el rol del servicio, no se pudo escribir en el directorio /etc/default/nis";
        exit 50;
    fi;

    echo "      -> Configurando los datos del servido en el fichero /etc/yp.conf";
    # Configure server location
    sshcmd $2 "echo 'domain $DOMAIN_NAME server $SERVER_ADDR' > /etc/yp.conf"
    if [[ $? -ne 0 ]]; then 
        echoerr "\n$1 linea $4: Error al configurar el nombre y direccion del servidor NIS."
        exit 51;
    fi

    echo "      -> Añadiendo el servicio nis a passwd en el fichero /etc/nsswitch.conf";
    # Configure /etc/nsswitch.conf
    sshcmd $2 "sed -i 's/passwd:         compat/passwd:         compat nis/g' /etc/nsswitch.conf"
    if [[ $? -ne 0 ]]; then 
        echoerr "\n$1 linea $4: Error al configurar la variable passwd en el fichero /etc/nsswitch.conf."
        exit 52;
    fi

    echo "      -> Añadiendo el servicio nis a group en el fichero /etc/nsswitch.conf";
    # Configure /etc/nsswitch.conf
    sshcmd $2 "sed -i 's/group:          compat/group:          compat nis/g' /etc/nsswitch.conf"
    if [[ $? -ne 0 ]]; then 
        echoerr "\n$1 linea $4: Error al configurar la variable group en el fichero /etc/nsswitch.conf."
        exit 53;
    fi

    echo "      -> Añadiendo el servicio nis a shadow en el fichero /etc/nsswitch.conf";
    # Configure /etc/nsswitch.conf
    sshcmd $2 "sed -i 's/shadow:         compat/shadow:         compat nis/g' /etc/nsswitch.conf"
    if [[ $? -ne 0 ]]; then 
        echoerr "\n$1 linea $4: Error al configurar la variable shadow en el fichero /etc/nsswitch.conf."
        exit 54;
    fi

    echo "      -> Añadiendo el servicio nis a host en el fichero /etc/nsswitch.conf";
    # Configure /etc/nsswitch.conf
    sshcmd $2 "sed -i 's/hosts:          files dns/hosts:          files dns nis/g' /etc/nsswitch.conf"
    if [[ $? -ne 0 ]]; then 
        echoerr "\n$1 linea $4: Error al configurar la variable hosts en el fichero /etc/nsswitch.conf."
        exit 55;
    fi

    echo "      -> Reiniciando el servicio NIS";
    # Start service
    sshcmd $2 "service nis restart"

    if [[ $? -ne 0 ]]; then 
        echoerr "\n$1 linea $4: Error al reiniciar el servicio NIS";
        exit 55;
    fi
}

export -f nisClientFunc
