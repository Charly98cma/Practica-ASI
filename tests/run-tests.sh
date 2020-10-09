#!/bin/bash

CMD="./configurar_cluster.sh"


# Test 1 - No argument
echo -n "Test 1... "
eval "$CMD &> /dev/null"
if [[ "$?" -ne 1 ]]; then
    echo "FAILED!"
    echo "Error - No pasar fichero de config no genera error"
    exit 1
fi
echo "SUCCESS"


# Test 2 - Argument file doesnt exist
echo -n "Test 2... "
eval "$CMD patata.txt &> /dev/null"
if [[ "$?" -ne 2 ]]; then
    echo "FAILED!"
    echo "Error - Pasar un fichero inexistente no genera error"
    exit
fi
echo "SUCCESS"


# Test 3 - Format error on a configuration line
echo -n "Test 3... "
eval "$CMD fichero-config--wrongformat.txt &> /dev/null"
if [[ "$?" -ne 3 ]]; then
    echo "FAILED!"
    echo "Error - Un error en el formato de una linea del fichero de configuracion no genera error"
    exit
fi
echo "SUCCESS"


# Test 4 - One of the config files of a service doesnt exist
echo -n "Test 4... "
eval "$CMD fichero-config--confignoexiste.txt &> /dev/null"
if [[ "$?" -ne 4 ]]; then
    echo "FAILED!"
    echo "Error - Que un fichero de config de un servicio no exista no genera error"
    exit
fi
echo "SUCCESS"
