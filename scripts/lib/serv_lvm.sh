#!/bin/bash
export "aux_functions.sh"

# LVM
# Params:
#
# Return:
#  0          - Success
#  Error code - Otherwise
lvmFunc() {

    assocDesc "3" "$3";
    read NAME <&3;
    read DEVS <&3;
    IFS=" " read -a DEVS_ARR <<< "$DEVS"



}
