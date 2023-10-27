#!/usr/bin/env bash

###########################################################
#                                                         #
# Author: b3nn3tt@hbcomputersecurity.co.uk                #
# Version: 1.0                                            #
# Git: https://github.com/b3nn3tt                         #
#                                                         #
# File Name:   display_banner.sh                          #
# Description: Prints the tool banner to the terminal     #
#                                                         #
###########################################################

display_banner(){
    local line="###############################################################"
    echo -e "\n${line}\n"
    echo -e "\t\tCIS Benchmark Deployment Tool\n"
    echo -e "\tRed Hat Enterprise Linux v9 Benchmark \033[1;32mv1.0.0\033[0m"
    echo -e "\n${line}\n"
}