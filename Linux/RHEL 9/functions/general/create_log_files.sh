#!/usr/bin/env bash

###########################################################
#                                                         #
# Author: b3nn3tt@hbcomputersecurity.co.uk                #
# Version: 1.0                                            #
# Git: https://github.com/b3nn3tt                         #
#                                                         #
# File Name:   create_log_files.sh                        #
# Description: Creates each log file                      #
#                                                         #
###########################################################

create_log_files(){
    
    # Create log directory for current run
    mkdir -p $CURRENT_LOG_DIR
    
    # Populate the header of each log file
    
    # Error Log - Created first to capture any errors when creating other log files
    echo -e "\033[1;93m[* CREATING *]\033[0m Creating error.log file in the following location:\n\n    \033[35m$ERROR_LOG\033[0m\n"
    sleep 2
    echo -e "\033[1;32m[+ COMPLETE +]\033[0m error.log file created successfully. Outputting log file header...\n"
    sleep 1
    {
        echo -e "*****************************************************************\n*************************** ERROR LOG ***************************\n*****************************************************************\n"
        echo -e "This log contains any errors encountered in the remediation process.\n\nFor a deeper dive into any issues, consult the CIS Benchmark PDF - use the recommendation number and title as a reference in the document.\n\nFor each item, there are sections that detail the recommendation, its impact, and guidelines for auditing and remediation. To address any errors and ensure the system aligns with the benchmark, adhere to these provided instructions.\n\nThis tool includes a copy of the benchmark PDF, located at:"
        echo -e "\n    \033[32m$PDF_LOCATION\033[0m\n"  # This line sets the text color to green for the variable and then resets it.
        echo -e "*****************************************************************\n"
    } | tee -a >(strip_ansi >> "$ERROR_LOG") 2>> "$ERROR_LOG"
    sleep 3
    
    # Summary Log
    echo -e "\033[1;93m[* CREATING *]\033[0m Creating summary.log file in the following location:\n\n    \033[35m$SUMMARY_LOG\033[0m\n"
    sleep 2
    echo -e "\033[1;32m[+ COMPLETE +]\033[0m summary.log file created successfully. Outputting log file header...\n"
    sleep 1
    {
        echo -e "*****************************************************************\n************************** SUMMARY LOG **************************\n*****************************************************************\n"
        echo -e "This log contains the outcomes for each benchmark test.\n\nFor a deeper dive into any issues, consult the CIS Benchmark PDF - use the recommendation number and title as a reference in the document.\n\nThis tool includes a copy of the benchmark PDF, located at:"
        echo -e "\n    \033[32m$PDF_LOCATION\033[0m\n"  # This line sets the text color to green for the variable and then resets it.
        echo -e "*****************************************************************\n"
    } | tee -a >(strip_ansi >> "$SUMMARY_LOG") 2>> "$ERROR_LOG"
    sleep 3
    
    # Fail Log
    echo -e "\033[1;93m[* CREATING *]\033[0m Creating failed.log file in the following location:\n\n    \033[35m$FAILED_LOG\033[0m\n"
    sleep 2
    echo -e "\033[1;32m[+ COMPLETE +]\033[0m failed.log file created successfully. Outputting log file header...\n"
    sleep 1
    {
        echo -e "*****************************************************************\n************************** FAILURE LOG **************************\n*****************************************************************\n"
        echo -e "This log contains a specific recommendation title that failed remediation and should be addressed.\n\nFor a deeper dive into any issues, consult the CIS Benchmark PDF - use the recommendation number and title as a reference in the document.\n\nFor each item, there are sections that detail the recommendation, its impact, and guidelines for auditing and remediation. To address any errors and ensure the system aligns with the benchmark, adhere to these provided instructions.\n\nThis tool includes a copy of the benchmark PDF, located at:"
        echo -e "\n    \033[32m$PDF_LOCATION\033[0m\n"  # This line sets the text color to green for the variable and then resets it.
        echo -e "*****************************************************************\n"
    } | tee -a >(strip_ansi >> "$FAILED_LOG") 2>> "$ERROR_LOG"
    sleep 3
    
    # Manual Log
    echo -e "\033[1;93m[* CREATING *]\033[0m Creating manual.log file in the following location:\n\n    \033[35m$MANUAL_LOG\033[0m\n"
    sleep 2
    echo -e "\033[1;32m[+ COMPLETE +]\033[0m manual.log file created successfully. Outputting log file header...\n"
    sleep 1
    {
        echo -e "*****************************************************************\n************************** MANUAL LOG ***************************\n*****************************************************************\n"
        echo -e "This log contains a specific recommendation title that requires manual remediation and should be addressed.\n\nTo address each manual recommendation effectively, refer to the related CIS Benchmark PDF and locate the specific recommendation by its number and title within the document. Each item will have steps for auditing and remediation. Adhere to these guidelines to ensure your system meets the benchmark standards.\n\nAfter executing the steps in the Remediation section, it's often beneficial to carry out the Audit section's procedures to confirm the remediation's success.\n\nThis tool includes a copy of the benchmark PDF, located at:"
        echo -e "\n    \033[32m$PDF_LOCATION\033[0m\n"  # This line sets the text color to green for the variable and then resets it.
        echo -e "*****************************************************************\n"
    } | tee -a >(strip_ansi >> "$MANUAL_LOG") 2>> "$ERROR_LOG"
    sleep 3
    
    echo -e "\033[1;32m[+ PROCESS COMPLETE +]\033[0m Log files successfully created.\n"
    sleep 3
    
    # Clear screen ready for next section of execution
    clear
}