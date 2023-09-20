#!/usr/bin/env bash

###########################################################
#                                                         #
# Author: b3nn3tt@hbcomputersecurity.co.uk                #
# Version: 1.0                                            #
# Git: https://github.com/b3nn3tt                         #
#                                                         #
# File Name:   run_recommendation.sh                      #
# Description: Executes the recommended actions for a     #
#              particular control                         #
#                                                         #
###########################################################

# This function is called on a per control basis
run_recommendation()
{
	# Passed the $RN variable to check for control applicability - returns an appropriate code
	recommendation_applicable
	oc1="$?"
	if [ "$oc1" = "101" ]; then
		# Calls the specified recommendation function
		#$REC
		#output_code="$?"
		echo -e "SUCCESS"
	else
		#output_code="$oc1"
		echo -e "FAIL BUT YAY"
	fi
	#remediation_output
	return
}