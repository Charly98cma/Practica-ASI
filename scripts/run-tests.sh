#!/bin/bash

# Basic command
CMD="./configurar_cluster.sh";

# Argument of each tests
TESTS=(
    ""
    "fich-que-no-existe"
    "tmp"
    "tests/tests-triviales/wrong-format.txt"
    "tests/tests-triviales/missing-file.txt"
    "tests/tests-triviales/unknown-service.txt"
    "tests/tests-mount/wrong-config-format.txt"
    "tests/tests-mount/disp-doesnt-exist.txt"
    "tests/tests-mount/point-not-empty.txt"
    "tests/tests-mount/point-created.txt"
    "tests/tests-mount/successful-config.txt"
)

# Expected results of each test
TEST_EXRES=(
    1
    2
    2
    3
    4
    5
    6
    8
    9
    0
    0
)

# Main loop
for (( i=0; i<"${#TESTS[@]}"; i++ )); do

    case $i in
	6)  echo "--- TESTS DE MOUNT ---"; ;;
	11) echo "--- TESTS DE RAID ---"; ;;
	*)  : ;;
    esac
    echo -n "Test $i... ";

    eval "$CMD ${TESTS[i]} &> /dev/null";
    if [[ "$?" -ne "${TEST_EXRES[i]}" ]]; then
	echo "FAILED! --> \"$CMD ${TESTS[i]} &> /dev/null\" => Error code received: $?";
	exit "$?";
    fi
    echo "SUCCESS";
done
