#!/usr/bin/env bash

###########################################################
#                                                         #
# Author: b3nn3tt@hbcomputersecurity.co.uk                #
# Version: 1.0                                            #
# Git: https://github.com/b3nn3tt                         #
#                                                         #
# File Name:   recommendation_applicable.sh               #
# Description: Output if a recommendation should be run   #
#                                                         #
###########################################################

recommendation_applicable() {
    # Checks to see if the control has been excluded from running
    if [ -s "$BASE_DIR"/exclusion_list.txt ]; then
        grep -Eq "^\s*$RN\b" "$BASE_DIR"/exclusion_list.txt && return "${XCCDF_RESULT_FAIL:-105}"
    elif [ -s "$BASE_DIR"/not_applicable_list.txt ]; then
        grep -Eq "^\s*$RN\b" "$BASE_DIR"/not_applicable_list.txt && return "${XCCDF_RESULT_FAIL:-104}"
    fi

    case "$RUN_PROFILE" in
        L1S|L1W)
            # Check if PROFILE matches the current RUN_PROFILE
            if echo "$PROFILE" | grep -Eq "$RUN_PROFILE\b"; then
                return "${XCCDF_RESULT_PASS:-101}"
            else
                return "${XCCDF_RESULT_FAIL:-107}"
            fi
            ;;
        L2S|L2W)
            # Check if PROFILE matches either L1 or L2 of the current server or workstation type
            if echo "$PROFILE" | grep -Eq "L[12]${RUN_PROFILE:2}\b"; then
                return "${XCCDF_RESULT_PASS:-101}"
            else
                return "${XCCDF_RESULT_FAIL:-107}"
            fi
            ;;
        *)
            return "${XCCDF_RESULT_FAIL:-102}"
            ;;
    esac
}
