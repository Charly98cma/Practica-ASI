#!/bin/bash

# Basic command
CMD="./configurar_cluster.sh";

# Argument of each tests
TESTS=(
    ""
    "fich-que-no-existe"
    "tmp"
    "tests-triviales/wrong-format.txt"
    "tests-triviales/missing-file.txt"
    "tests-triviales/unknown-service.txt"
)

# Expected results of each test
TEST_EXRES=(
    1
    2
    2
    3
    4
    5
)

# Main loop
for (( i=0; i<"${#TESTS[@]}"; i++ )); do
    echo -n "Test $i... ";
    eval "$CMD ${TESTS[i]} &> /dev/null";
    if [[ "$?" -ne "${TEST_EXRES[i]}" ]]; then
	echo "FAILED! --> \"$CMD ${TESTS[i]} &> /dev/null\" => Error code received: $?";
	exit "$?";
    fi
    echo "SUCCESS";
done
