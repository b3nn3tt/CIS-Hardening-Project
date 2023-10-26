#!/usr/bin/env bash

########################################################################
#                                                                      #
# Author: b3nn3tt@hbcomputersecurity.co.uk                             #
# Version: 1.0                                                         #
# Git: https://github.com/b3nn3tt                                      #
#                                                                      #
# File Name:   RHEL9_1.7.4_ensure_permissions_motd_configured.sh       #
# Description: Ensures permissions on /etc/motd are configured         #
#                                                                      #
########################################################################

ensure_permissions_motd_configured()
{
	# Ensure permissions and owner/group on /etc/motd are configured
	echo
	echo -e "\n**************************************************\n- $(date +%d-%b-%Y' '%T)\n- Start Recommendation \"$RN - $RNA\"" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
	l_test=""
	l_perms_correct="0644"
	l_uid_correct="root"
	l_gid_correct="root"
	
	# If either the UID or GID is not correct, set the variable l_uid to "failed".  We will fix both of them even if one is already correct.
	ensure_permissions_motd_configured_chk()
	{
		# Checks for correctly set permissions and ownership
		echo "- Start check - /etc/motd permissions set to \"$l_perms_correct\", ownership set to \"$l_uid_correct\", and group set to \"$l_gid_correct\"" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
		
		if [ -e /etc/motd ]; then
			l_buffer=$(stat -L /etc/motd | grep -i access | grep -i id)
			l_perms=$(echo $l_buffer | awk '{print $2}' | cut -d'/' -f1 | sed "s/(//g")
			l_uid=$(echo $l_buffer |  awk '{print $6}' | sed "s/)//g")
			l_gid=$(echo $l_buffer |  awk '{print $NF}' | sed "s/)//g")
			l_ownergroup=""
			l_permissions=""

			if [ "$l_perms" != "$l_perms_correct" ]; then
				l_permissions="failed"
			fi

			if [ "$l_uid" != "$l_uid_correct" ] || [ "$l_gid" != "$l_gid_correct" ]; then
				l_ownergroup="failed"
			fi

			# If $l_permissions does not equal "failed" and $l_ownergroup does not equal "failed", we pass
			if [ "$l_permissions" != "failed" ] && [ "$l_ownergroup" != "failed" ]; then
				echo -e "- PASS:\n- /etc/motd permissions set to \"$l_perms_correct\", ownership set to \"$l_uid_correct\", and group set to \"$l_gid_correct\""  | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
				echo "- End check - /etc/motd permissions and ownership" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
				return "${XCCDF_RESULT_PASS:-101}"
			else
				# print the reason why we are failing
				echo "- FAILED:"  | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
				[ "$l_perms" != "$l_perms_correct" ] && echo "- /etc/motd permissions are set to \"$l_perms\"" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
				[ "$l_uid" != "$l_uid_correct" ] && [ "$l_gid" != "$l_gid_correct" ] && echo "- /etc/motd owner is \"$l_uid\" and group is \"$l_gid\"" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
				echo "- End check - /etc/motd permissions and ownership" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
				return "${XCCDF_RESULT_FAIL:-102}"
			fi
		else
			echo -e "- PASS:\n- /etc/motd  does NOT exist"  | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			echo -e "- End check - Ensure permissions on /etc/motd are configured" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			return "${XCCDF_RESULT_PASS:-101}"
		fi					
	}

	ensure_permissions_motd_configured_fix()
	{
		echo "- Start remediation - set: /etc/motd permissions to \"$l_perms_correct\", ownership to \"$l_uid_correct\", and group to \"$l_gid_correct\"" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
		if [ "$l_permissions" = "failed" ]; then
			echo "- Remediating /etc/motd permissions set incorrectly to \"$l_perms\"" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"	
			chmod -t,u+r+w-x-s,g+r-w-x-s,o+r-w-x /etc/motd
		fi

		if [ "$l_ownergroup" = "failed" ]; then
			echo "- Remediating /etc/motd owner and group set incorrectly to \"$l_uid\" and \"$l_gid\"" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
 			chown root:root /etc/motd
		fi
	}

	ensure_permissions_motd_configured_chk
	if [ "$?" = "101" ]; then
		[ -z "$l_test" ] && l_test="passed"
	else
		ensure_permissions_motd_configured_fix
		ensure_permissions_motd_configured_chk
		if [ "$?" = "101" ]; then
			[ "$l_test" != "failed" ] && l_test="remediated"
		else
			l_test="failed"
		fi
	fi

	# Set return code and return
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
