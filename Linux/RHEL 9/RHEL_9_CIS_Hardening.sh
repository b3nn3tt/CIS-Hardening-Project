#!/usr/bin/env bash

###########################################################
#                                                         #
# Author: b3nn3tt@hbcomputersecurity.co.uk                #
# Version: 1.0                                            #
# Git: https://github.com/b3nn3tt                         #
#                                                         #
# File Name:   RHEL_9_CIS_Hardening.sh                    #
#                                                         #
###########################################################

# Ensure script is executed in bash
if [ ! "$BASH_VERSION" ] ; then
    exec /bin/bash "$0" "$@"
fi

# Ensure script is running with root privileges (REQUIRED)
if [ "$EUID" -ne 0 ]; then
    echo -e "\e[1;31m[*] ERROR [*]\e[0m The CIS Benchmark Deployment Tool must be run with \e[1;31mroot privileges\e[0m. This process will now terminate..."
    exit 1
fi

####################################
##### GLOBAL VARIABLES SECTION #####
####################################

# Current Date Time Group at time of execution
DTG=$(date +%m-%d-%Y_%H%M)

# Directories
BASE_DIR="$(dirname "$(readlink -f "$0")")"
FUNC_DIR=$BASE_DIR/functions
REC_DIR=$FUNC_DIR/recommendations
GEN_DIR=$FUNC_DIR/general
LOG_DIR=$BASE_DIR/logs
RESOURCES_DIR=$BASE_DIR/resources
CURRENT_LOG_DIR=$LOG_DIR/$DTG

# Log Files
VERBOSE_LOG=$CURRENT_LOG_DIR/verbose.log
SUMMARY_LOG=$CURRENT_LOG_DIR/summary.log
ERROR_LOG=$CURRENT_LOG_DIR/error.log
FAILED_LOG=$CURRENT_LOG_DIR/failed.log
MANUAL_LOG=$CURRENT_LOG_DIR/manual.log

# CIS PDF Reference
PDF_LOCATION=$(find $RESOURCES_DIR -type f -name "*.pdf")

# Counters
PASSED_RECOMMENDATIONS="0"
FAILED_RECOMMENDATIONS="0"
REMEDIATED_RECOMMENDATIONS="0"
NOT_APPLICABLE_RECOMMENDATIONS="0"
EXCLUDED_RECOMMENDATIONS="0"
MANUAL_RECOMMENDATIONS="0"
SKIPPED_RECOMMENDATIONS="0"
TOTAL_RECOMMENDATIONS="0"


#####################################
##### IMPORT REQUIRED FUNCTIONS #####
#####################################

# General Functions
for FUNC in "$GEN_DIR"/*.sh; do
	[ -e "$FUNC" ] || break
	. "$FUNC"
done

# CIS Recommendation Functions
for FUNC in "$REC_DIR"/**/*.sh; do
	[ -e "$FUNC" ] || break
	. "$FUNC"
done

####################################
######### EXECUTION BEGINS #########
####################################

# Clear Screen
clear

# Display Banner
display_banner

# Display Warning Message
warning
sleep 3

# Create Log Files
create_log_files

# Select which CIS Control Level to implement
select_control_level

#######################################
######### CIS RECOMMENDATIONS #########
#######################################

########## 1. INITIAL SETUP ##########

# 1.1 - Filesystem Configuration
RN="1.1"
RNA="Ensure system-wide crypto policy is not legacy"
PROFILE="L1S L1W"
REC="fed_ensure_system-wide_crypto_policy_not_legacy"
FSN="RHEL9_fed_ensure_system-wide_crypto_policy_not_legacy.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

# 1.1.1 - Disable unused filesystems
RN="1.1.1.1"
RNA="Ensure mounting of squashfs filesystems is disabled"
PROFILE="L2S L2W"
REC="ensure_squashfs_filesystem_disabled"
FSN="RHEL9_ensure_squashfs_filesystem_disabled.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation