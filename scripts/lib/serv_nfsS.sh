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
nfsServerFunc() {
    eval "ssh -o \"StrictHostKeyChecking=no\" root@$2 \"echo $line $IP(rw,sync,no_subtree_check) >> /etc/exports\" < /dev/null &> /dev/null";

    # Package management
    packageMng $2 "nfsS"
    if [[ $? -ne 0 ]]; then
        exit 255;
    fi

    # Iterate over directories to export
    while IFS= read -r line; do
        # Check if the directory exists in host
        sshcmd $2 "[[ -d $line ]]" < /dev/null
        if [[ $? -ne 0 ]]; then
            echoerr "ERROR - El directorio '$line' no existe";
            exit 70;
        fi
        # Check if the /etc/exports file exists
        sshcmd $2 "[[ -f /etc/exports ]]" < /dev/null
        if [[ $? -ne 0 ]]; then
            echoerr "ERROR - El fichero /etc/exports no existe";
            exit 71;
        fi

        # Get all host subnet IP's
        hostIPs=$(ssh -o "StrictHostKeyChecking=no" root@$2 "ip route" < /dev/null);
        # Add directories to export to the /etc/exports file for each subnet
        i=0;
        while read -r IPline; do
            if [ $i -eq 0 ]; then
                i=1;
                continue;
            fi
            IP=$(echo $IPline | awk {'print $1'})
            echo "      -> Añadiendo $line $IP(rw,sync,no_subtree_check) en /etc/exports"
            eval "ssh -o \"StrictHostKeyChecking=no\" root@$2 \"echo '$line $IP(rw,sync,no_subtree_check)' >> /etc/exports\" < /dev/null &> /dev/null";
            if [[ $? -ne 0 ]]; then
                echoerr "ERROR - Error inesperado al añadir el directorio $line en /etc/exports";
                exit 72;
            fi
            echo "      -> Directorio añadido correctamente."
        done <<< "$hostIPs";
    done < $3;

    # Apply exports
    echo "      -> Aplicando los cambios..."
    sshcmd $2 "exportfs -ra"
    if [[ $? -ne 0 ]]; then
        echoerr "ERROR - Error inesperado al aplicar los cambios en /etc/exports";
        exit 73;
    fi

    # Reset the server
    echo "      -> Reiniciando el servicio..."
    sshcmd $2 "service nfs-kernel-server restart"
    if [[ $? -ne 0 ]]; then
        echoerr "ERROR - Error inesperado al reiniciar el servicio nfs-kernel-service";
        exit 74;
    fi

    # # configure firewall in order to allow trafic
    # # sshcmd $2 "ufw allow from IPSUBNET to any port nfs"
    exit 0;
}

export -f nfsServerFunc
