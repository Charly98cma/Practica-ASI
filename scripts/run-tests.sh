#!/bin/bash

# Basic command
CMD="./configurar_cluster.sh";

# Argument of each tests
TESTS=(
    "" #0
    "fich-que-no-existe" #1
    "tmp" #2

    "tests/tests-triviales/wrong-format.txt" #3
    "tests/tests-triviales/missing-file.txt" #4
    "tests/tests-triviales/unknown-service.txt" #5

    "tests/tests-mount/wrong-config-format.txt" #6
    "tests/tests-mount/disp-doesnt-exist.txt" #7
    "tests/tests-mount/point-not-empty.txt" #8
    "tests/tests-mount/point-created.txt" #9
    "tests/tests-mount/successful-config.txt" #10

    "tests/tests-raid/wrong-config-format.txt" #11
    "tests/tests-raid/wrong-raid-level-config.txt" #12
    "tests/tests-raid/disp-with-fs-config.txt" #13

    "tests/tests-lvm/wrong-config-format.txt" #14
    "tests/tests-lvm/disp-doesnt-exist.txt" #15
    "tests/tests-lvm/too-many-lvs.txt" #16
    "tests/tests-lvm/successful-lvm.txt" #17

    "tests/tests-nisS/sucess.txt"#18

    "tests/tests-nisC/success.txt"#19

    "tests/tests-backupC/wrong-config-format.txt"#20
    "tests/tests-backupC/unknown-backup-source.txt"#21
    "tests/tests-backupC/unknown-backup-destiny.txt"#22
    "tests/tests-backupC/bad-backup-frequency.txt"#23
    "tests/tests-backupC/successful-backup.txt"#24

    "tests/tests-backupS/wrong-config-format.txt"#25
    "tests/tests-backupS/backup-dir-doesnt-exist.txt"#26
    "tests/tests-backupS/nonempty-backup-dir.txt"#27
    "tests/tests-backupS/successful-backupS.txt"#28
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

    0
    0

    6
    80
    81
    82
    0

    6
    90
    91
    0
);

# Main loop
for (( i=0; i<${#TESTS[@]}; i++ )); do
    case $i in
	0)  echo -e "\n--- TESTS CLIENTE ---\n"; ;;
	3)  echo -e "\n--- TESTS TRIVIALES ---\n"; ;;
	6)  echo -e "\n--- TESTS DE MOUNT ---\n"; ;;
	11) echo -e "\n--- TESTS DE RAID ---\n"; ;;
	14) echo -e "\n--- TESTS DE LVM ---\n"; ;;
	18) echo -e "\n--- TESTS DE NIS ---\n"; ;;
	# XX) echo -e "\n--- TESTS DE NFS ---\n"; ;;
	20) echo -e "\n--- TESTS DE BACKUP ---\n"; ;;
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
