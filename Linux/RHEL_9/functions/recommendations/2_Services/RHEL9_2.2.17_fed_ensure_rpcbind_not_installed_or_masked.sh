#!/usr/bin/env bash

##############################################################################
#                                                                            #
# Author: b3nn3tt@hbcomputersecurity.co.uk                                   #
# Version: 1.0                                                               #
# Git: https://github.com/b3nn3tt                                            #
#                                                                            #
# File Name:   RHEL9_2.2.17_fed_ensure_rpcbind_not_installed_or_masked.sh    #
# Description: Ensures RPC is not enabled                                    #
#                                                                            #
##############################################################################

fed_ensure_rpcbind_not_installed_or_masked()
{
	# Start recommendation entry for verbose log and output to screen
	echo -e "\n**************************************************\n- $(date +%d-%b-%Y' '%T)\n- Start Recommendation \"$RN - $RNA\"" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
	l_test=""

	fed_ensure_rpcbind_not_installed_or_masked_chk()
	{
		# If rpc is not installed, we pass.	
		if rpm -q rpcbind | grep "not installed" > /dev/null; then
			echo -e "- PASS \"$RNA\" No remediation required" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			echo -e "- Result - rpcbind not installed\n- End Recommendation \"$RN - $RNA\"\n**************************************************\n" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			return "${XCCDF_RESULT_FAIL:-101}"
		# If rpcbind is installed, we verify that both rpcbind and rpcbind.socket are masked
		elif systemctl is-enabled rpcbind | grep -E "^masked$" > /dev/null && systemctl is-enabled rpcbind.socket | grep -E "^masked$" > /dev/null; then
			echo -e "- PASS \"$RNA\" No remediation required" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			echo -e "- Result - rpc is installed but rpcbind service and rpcbind.socket service are masked\n- End Recommendation \"$RN - $RNA\"\n**************************************************\n" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			return "${XCCDF_RESULT_FAIL:-101}"
		else
			echo -e "- Result - needs remediation\n- End Recommendation \"$RN - $RNA\"\n**************************************************\n" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			return "${XCCDF_RESULT_FAIL:-102}"
		fi
	}

	fed_ensure_rpcbind_not_installed_or_masked_fix()
	{
		echo "- Start remediation - masking rpcbind service and/or rpcbind.socket service" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
		! systemctl is-enabled rpcbind | grep -E "^masked$" && (systemctl --now mask rpcbind && l_test=remediated)
		! systemctl is-enabled rpcbind.socket | grep -E "^masked$" && (systemctl --now mask rpcbind.socket && l_test=remediated)
	}

	fed_ensure_rpcbind_not_installed_or_masked_chk
	if [ "$?" = "101" ]; then
		[ -z "$l_test" ] && l_test="passed"
	else
		fed_ensure_rpcbind_not_installed_or_masked_fix
		fed_ensure_rpcbind_not_installed_or_masked_chk
		if [ "$?" = "101" ]; then
			[ "$l_test" != "failed" ] && l_test="remediated"
		else
			l_test="failed"
		fi
	fi
	
	# Set return code, end recommendation entry in verbose log, and return
	case "$l_test" in
		passed)
			echo -e "- Result - No remediation required\n- End Recommendation \"$RN - $RNA\"\n**************************************************\n" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			return "${XCCDF_RESULT_PASS:-101}"
			;;
		remediated)
			echo -e "- Result - successfully remediated\n- End Recommendation \"$RN - $RNA\"\n**************************************************\n" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			return "${XCCDF_RESULT_PASS:-103}"
			;;
		manual)
			echo -e "- Result - requires manual remediation\n- End Recommendation \"$RN - $RNA\"\n**************************************************\n" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			return "${XCCDF_RESULT_FAIL:-106}"
			;;
		NA)
			echo -e "- Result - Recommendation is non applicable\n- End Recommendation \"$RN - $RNA\"\n**************************************************\n" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			return "${XCCDF_RESULT_PASS:-104}"
			;;
		*)
			echo -e "- Result - remediation failed\n- End Recommendation \"$RN - $RNA\"\n**************************************************\n" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			return "${XCCDF_RESULT_FAIL:-102}"
			;;
	esac
}