#!/usr/bin/env bash

##############################################################################
#                                                                            #
# Author: b3nn3tt@hbcomputersecurity.co.uk                                   #
# Version: 1.0                                                               #
# Git: https://github.com/b3nn3tt                                            #
#                                                                            #
# File Name:   RHEL9_2.2.16_fed_ensure_nfs_server_not_installed_or_masked.sh #
# Description: Ensures NFS is not enabled                                    #
#                                                                            #
##############################################################################

fed_ensure_nfs_server_not_installed_or_masked()
{
	# Start recommendation entry for verbose log and output to screen
	echo -e "\n**************************************************\n- $(date +%d-%b-%Y' '%T)\n- Start Recommendation \"$RN - $RNA\"" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
	l_test=""

	fed_ensure_nfs_server_not_installed_or_masked_chk()
	{
		# If nfs-utils is not installed, we pass.	
		if rpm -q nfs-utils | grep "not installed" > /dev/null; then
			echo -e "- PASS \"$RNA\" No remediation required" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			echo -e "- Result - nfs-utils not installed\n- End Recommendation \"$RN - $RNA\"\n**************************************************\n" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			return "${XCCDF_RESULT_FAIL:-101}"
		# If nfs-utils is installed, we verify it is masked
		elif systemctl is-enabled nfs-server | grep -E "^masked$" > /dev/null; then
			echo -e "- PASS \"$RNA\" No remediation required" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			echo -e "- Result - nfs-utils is installed but nfs-server service is masked\n- End Recommendation \"$RN - $RNA\"\n**************************************************\n" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			return "${XCCDF_RESULT_FAIL:-101}"
		else
			echo -e "- Result - remediation required\n- End Recommendation \"$RN - $RNA\"\n**************************************************\n" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			return "${XCCDF_RESULT_FAIL:-102}"
		fi
	}

	fed_ensure_nfs_server_not_installed_or_masked_fix()
	{
		echo "- Start remediation - masking nfs-server service" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
		systemctl --now mask nfs-server
	}

	fed_ensure_nfs_server_not_installed_or_masked_chk
	if [ "$?" = "101" ]; then
		[ -z "$l_test" ] && l_test="passed"
	else
		fed_ensure_nfs_server_not_installed_or_masked_fix
		fed_ensure_nfs_server_not_installed_or_masked_chk
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