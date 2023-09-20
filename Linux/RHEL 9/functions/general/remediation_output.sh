#!/usr/bin/env bash

###########################################################
#                                                         #
# Author: b3nn3tt@hbcomputersecurity.co.uk                #
# Version: 1.0                                            #
# Git: https://github.com/b3nn3tt                         #
#                                                         #
# File Name:   remediation_output.sh                      #
# Description: Outputs remediation to appropriate logs    # 
#              then updates recommendation counters       #
#                                                         #
###########################################################

# Called by run_recommendation on a per-control basis
remediation_output()
{
	case "$output_code" in
		101)
			passed_recommendations=$((passed_recommendations+1))
			echo "*****************************************************************" | tee -a "$SUMMARY_LOG" 2>> "$ERROR_LOG"
			echo " - $RN - $RNA -" | tee -a "$SUMMARY_LOG" 2>> "$ERROR_LOG"
			echo " - PASSED - Remediation not required" | tee -a "$SUMMARY_LOG" 2>> "$ERROR_LOG"
			echo "*****************************************************************" | tee -a "$SUMMARY_LOG" 2>> "$ERROR_LOG"
			;;
		102)
			failed_recommendations=$((failed_recommendations+1))
			echo "*****************************************************************" | tee -a "$SUMMARY_LOG" 2>> "$ERROR_LOG"
			echo " - $RN - $RNA -" | tee -a "$SUMMARY_LOG" 2>> "$ERROR_LOG"
			echo " - FAILED - Recommendation failed remediation" | tee -a "$SUMMARY_LOG" 2>> "$ERROR_LOG"
			echo "*****************************************************************" | tee -a "$SUMMARY_LOG" 2>> "$ERROR_LOG"
			# Send Failed Recommendations to the FRLOG
			echo "*****************************************************************" | tee -a "$SUMMARY_LOG" 2>> "$ERROR_LOG"
			echo " - $RN - $RNA -" | tee -a "$FAILED_LOG" 2>> "$ERROR_LOG"
			echo " - FAILED - Recommendation failed remediation" | tee -a "$FAILED_LOG" 2>> "$ERROR_LOG"
			echo "*****************************************************************" | tee -a "$FAILED_LOG" 2>> "$ERROR_LOG"
			;;
		103)
			remediated_recommendations=$((remediated_recommendations+1))
			echo "*****************************************************************" | tee -a "$SUMMARY_LOG" 2>> "$ERROR_LOG"
			echo " - $RN - $RNA -" | tee -a "$SUMMARY_LOG" 2>> "$ERROR_LOG"
			echo " - REMEDIATED - Recommendation successfully remediated" | tee -a "$SUMMARY_LOG" 2>> "$ERROR_LOG"
			echo "*****************************************************************" | tee -a "$SUMMARY_LOG" 2>> "$ERROR_LOG"
			;;
		104)
			not_applicable_recommendations=$((not_applicable_recommendations+1))
			echo "*****************************************************************" | tee -a "$SUMMARY_LOG" 2>> "$ERROR_LOG"
			echo " - $RN - $RNA -" | tee -a "$SUMMARY_LOG" 2>> "$ERROR_LOG"
			echo " - N/A - Recommendation is non applicable" | tee -a "$SUMMARY_LOG" 2>> "$ERROR_LOG"
			echo "*****************************************************************" | tee -a "$SUMMARY_LOG" 2>> "$ERROR_LOG"
			;;
		105)
			excluded_recommendations=$((excluded_recommendations+1))
			echo "*****************************************************************" | tee -a "$SUMMARY_LOG" 2>> "$ERROR_LOG"
			echo " - $RN - $RNA -" | tee -a "$SUMMARY_LOG" 2>> "$ERROR_LOG"
			echo " - EXCLUDED - Recommendation on the excluded list" | tee -a "$SUMMARY_LOG" 2>> "$ERROR_LOG"
			echo "*****************************************************************" | tee -a "$SUMMARY_LOG" 2>> "$ERROR_LOG"
			;;
		106)
			manual_recommendations=$((manual_recommendations+1))
			echo "*****************************************************************" | tee -a "$SUMMARY_LOG" 2>> "$ERROR_LOG"
			echo " - $RN - $RNA -" | tee -a "$SUMMARY_LOG" 2>> "$ERROR_LOG"
			echo " - MANUAL - Recommendation needs to be remediated manually" | tee -a "$SUMMARY_LOG" 2>> "$ERROR_LOG"
			echo "*****************************************************************" | tee -a "$SUMMARY_LOG" 2>> "$ERROR_LOG"
			# Send Manual recommendations to the MANLOG
			echo "*****************************************************************" | tee -a "$MANUAL_LOG" 2>> "$ERROR_LOG"
			echo " - $RN - $RNA -" | tee -a "$MANUAL_LOG" 2>> "$ERROR_LOG"
			echo " - MANUAL - Recommendation needs to be remediated manually" | tee -a "$MANUAL_LOG" 2>> "$ERROR_LOG"
			echo "*****************************************************************" | tee -a "$MANUAL_LOG" 2>> "$ERROR_LOG"
			;;
		107)
			skipped_recommendations=$((skipped_recommendations+1))
			echo "*****************************************************************" | tee -a "$SUMMARY_LOG" 2>> "$ERROR_LOG"
			echo " - $RN - $RNA -" | tee -a "$SUMMARY_LOG" 2>> "$ERROR_LOG"
			echo " - SKIPPED - Recommendation not in selected profile" | tee -a "$SUMMARY_LOG" 2>> "$ERROR_LOG"
			echo "*****************************************************************" | tee -a "$SUMMARY_LOG" 2>> "$ERROR_LOG"
			;;
		201)
			remediated_recommendations=$((remediated_recommendations+1))
			echo "*****************************************************************" | tee -a "$SUMMARY_LOG" 2>> "$ERROR_LOG"
			echo " - $RN - $RNA -" | tee -a "$SUMMARY_LOG" 2>> "$ERROR_LOG"
			echo " - REMEDIATED - Recommendation remediation run" | tee -a "$SUMMARY_LOG" 2>> "$ERROR_LOG"
			echo "*****************************************************************" | tee -a "$SUMMARY_LOG" 2>> "$ERROR_LOG"
			;;
		*)
			echo "*****************************************************************" | tee -a "$SUMMARY_LOG" 2>> "$ERROR_LOG"
			echo " - $RN - $RNA -" | tee -a "$SUMMARY_LOG" 2>> "$ERROR_LOG"
			echo " - ERROR - Output code not set" | tee -a "$SUMMARY_LOG" 2>> "$ERROR_LOG"
			echo "*****************************************************************" | tee -a "$SUMMARY_LOG" 2>> "$ERROR_LOG"
			return "${XCCDF_RESULT_FAIL:-108}"
			;;
	esac
	output_code=""
}