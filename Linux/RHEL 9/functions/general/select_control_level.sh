#!/usr/bin/env bash

###########################################################
#                                                         #
# Author: b3nn3tt@hbcomputersecurity.co.uk                #
# Version: 1.0                                            #
# Git: https://github.com/b3nn3tt                         #
#                                                         #
# File Name:   select_control_level.sh                    #
# Description: Prompts the user to select which CIS level #
#              controls to deploy (1 or 2), and specify   #
#              a workstation or server profile            #
#                                                         #
###########################################################


select_control_level() {
    # Creates an associative array named "PROFILES" - much easier to add to later
    declare -A PROFILES
    PROFILES=(
        [1]="L1S"
        [2]="L1W"
        [3]="L2S"
        [4]="L2W"
    )

    request_profile() {
        echo -e "\033[1;93m[- SELECT -]\033[0m Select the number corresponding to your desired profile:\n"
        for KEY in {1..4}; do  # This ensures the correct display order
            echo -e "\t$KEY: ${PROFILES[$KEY]}\n"
        done
        
        read -p "Profile: " P
        
        RUN_PROFILE=${PROFILES[$P]}

        if [ -z "$RUN_PROFILE" ]; then
            echo -e "\n\e[1;31m[* ERROR *]\e[0m Invalid option selection: $P\n"
            request_profile
        fi
    }

    # If RUN_PROFILE doesn't exist, prompt for user selection
    if [ -z "$RUN_PROFILE" ] || [[ ! ${PROFILES[*]} =~ $RUN_PROFILE ]]; then
        request_profile
    fi    
}
