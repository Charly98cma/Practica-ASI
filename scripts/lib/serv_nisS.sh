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
    read HOST_NAME <&3; # Name of the NIS domain
    exec 3<&-;

    # Check if the argument exist
    if [[ $HOST_NAME == ""]]; then
	echoWrongParams $1 $4 $3;
	exit 6;
    fi

    # Role configuration
    sshcmd $2 "echo NISSERVER=master > /etc/default/nis"
    if [[ $? -ne 0]]; then 
    echoerr "\n$1 linea $4: Error al configurar el rol del servidor, no se pudo escribir en el directorio /etc/default/nis"
    exit 10;

    #Configure which devices have access to the NIS server
    sshcmd $2 "echo '255.255.255.0   10.0.0.0' >> /etc/ypserv.securenets"
    if [[ $? -ne 0]]; then 
    echoerr "\n$1 linea $4: Error al configurar el rango de direcciones ip que tienen acceso al servidor NIS"
    exit 11;

    # Store passwords on the NIS server too
    sshcmd $2 "sed -i 's/MERGE_PASSWD=false/MERGE_PASSWD=true/' /var/yp/Makefile"
    if [[ $? -ne 0]]; then 
    echoerr "\n$1 linea $4: Error al configurar el fichero /var/yp/Makefile"
    exit 12;

    sshcmd $2 "sed -i 's/MERGE_GROUP=false/MERGE_GROUP=true/' /var/yp/Makefile"
    if [[ $? -ne 0]]; then 
    echoerr "\n$1 linea $4: Error al configurar el fichero /var/yp/Makefile"
    exit 13;

    # Configure /etc/hosts
    sshcmd $2 "echo '$2     $HOST_NAME' >> /etc/hosts"
    if [[ $? -ne 0]]; then 
    echoerr "\n$1 linea $4: Error al configurar /etc/hosts para añadir el servicio NIS"
    exit 14;

    #Update NIS database
    sshcmd $2 "/usr/lib/yp/ypinit -m < /dev/null"
    if [[ $? -ne 0]]; then 
    echoerr "\n$1 linea $4: Error al configurar la base de datos de NIS"
    exit 15;

    # Start service
    sshcmd $2 "service nis restart"
    if [[ $? -ne 0]]; then 
    echoerr "\n$1 linea $4: Error al reiniciar el servicio NIS"
    exit 16;
}