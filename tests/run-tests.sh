#!/bin/bash

# Basic command
CMD="./configurar_cluster.sh";

# Argument of each tests
TESTS=(
    ""
    "patata.txt"
    "fichero-config--wrongformat.txt"
    "fichero-config--confignoexiste.txt"
)

# Expected results of each test
TEST_EXRES=(
    1
    2
    3
    4
)

# Main loop
for (( i=0; i<"${#TESTS[@]}"; i++ )); do
    echo -n "Test $i... ";
    eval "$CMD ${TESTS[i]} &> /dev/null";
    if [[ "$?" -ne "${TEST_EXRES[i]}" ]]; then
	echo "FAILED! --> $CMD ${TESTS[i]} &> /dev/null";
	exit "$?";
    fi
    echo "SUCCESS";
done
