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
    "tests/tests-raid/wrong-config-format.txt"
    "tests/tests-raid/wrong-raid-level-config.txt"
    "tests/tests-raid/disp-with-fs-config.txt"

    "wrong-config-format.txt"
    "disp-doesnt-exist.txt"
    "too-many-lvs.txt"

    "successful-lvm.txt"
);

# Expected results of each test
TEST_EXRES=(
    1
    2
    2
    3
    4
    5
    6
    10
    11
    0
    0
    6
    21
    22

    6
    30
    33

    0
);

# Main loop
for (( i=0; i<${#TESTS[@]}; i++ )); do
    case $i in
	0)  echo -e "\n--- TESTS CLIENTE   ---\n"; ;;
	3)  echo -e "\n--- TESTS TRIVIALES ---\n"; ;;
	6)  echo -e "\n--- TESTS DE MOUNT  ---\n"; ;;
	11) echo -e "\n--- TESTS DE RAID   ---\n"; ;;
	14) echo -e "\n--- TESTS DE LVM    ---\n"; ;;
	*)  : ;;
    esac
    echo -n "Test $i... ";

    eval "$CMD ${TESTS[i]} &> /dev/null";
    RES=$?
    if [[ $RES -ne ${TEST_EXRES[i]} ]]; then
	echo "FAILED!";
	echo -e "\n$CMD ${TESTS[i]} &> /dev/null\\n\tError code expected: ${TEST_EXRES[i]}\n\tError code received: $RES\n";
	# Uncomment next line to stop on the first failure
	# exit $RES;
    else
	echo "SUCCESS";
    fi
done
