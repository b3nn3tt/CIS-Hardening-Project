#!/usr/bin/env bash

###########################################################
#                                                         #
# Author: b3nn3tt@hbcomputersecurity.co.uk                #
# Version: 1.0                                            #
# Git: https://github.com/b3nn3tt                         #
#                                                         #
# File Name:   RHEL_9_CIS_Hardening.sh                    #
# Description: Strips ANSI characters from log files      #
#                                                         #
###########################################################

strip_ansi() {
    sed 's/\x1b\[[0-9;]*m//g'
}