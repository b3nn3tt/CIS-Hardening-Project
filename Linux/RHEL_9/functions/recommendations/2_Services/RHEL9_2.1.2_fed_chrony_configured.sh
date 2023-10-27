#!/usr/bin/env sh

########################################################################
#                                                                      #
# Author: b3nn3tt@hbcomputersecurity.co.uk                             #
# Version: 1.0                                                         #
# Git: https://github.com/b3nn3tt                                      #
#                                                                      #
# File Name:   RHEL9_2.1.2_fed_chrony_configured.sh                    #
# Description: Ensures chrony is configured                            #
#                                                                      #
########################################################################

fed_chrony_configured()
{
	echo
	echo -e "\n**************************************************\n- $(date +%d-%b-%Y' '%T)\n- Start Recommendation \"$RN - $RNA\"" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
	l_test=""

	fed_chrony_configured_chk()
	{
		l_config=""		
		l_options=""
		# If chrony is installed, verify server/pool is configured in /etc/chrony.conf, and OPTIONS are set correctly in /etc/sysconfig/chronyd.
		echo "- Start check - chrony configuration" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
		if rpm -q chrony >/dev/null; then
			# Determine if server/pool set correctly.
			if grep -E "^(server|pool)\s+\S+" /etc/chrony.conf > /dev/null; then
				:
			else
				l_config="manual"
			fi
		
			# Determine if OPTIONS is set correctly
			if grep -E "^\s*OPTIONS\s*=\s*\".*?-u\s+chrony.*?\"" /etc/sysconfig/chronyd > /dev/null; then
				:
			else
				l_options="failed"
			fi
		
			# If server/pool not set in /etc/chrony.conf, return a 106 so user can manually remediate both the conditions in /etc/chrony.conf and /etc/sysconfig/chronyd, if necessary.
			# If /etc/sysconfig/chronyd OPTIONS not set correctly, return a FAIL 102 and tell the user what file needs to be modified.
			# Otherwise, just return a generic fail.
			if [ -z "$l_config" -a -z "$l_options" ]; then
				echo -e "- PASS:\n- chrony is configured correctly"  | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
		   		echo "- End check - chrony configuration" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
		   		return "${XCCDF_RESULT_PASS:-101}"
			elif [ "$l_config" = "manual" ]; then
				echo -e "- Recommendation \"$RNA\" Manual remediation required" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
				echo -e "- Result - requires manual remediation\n- End Recommendation \"$RN - $RNA\"\n**************************************************\n" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
				return "${XCCDF_RESULT_FAIL:-106}"
			elif [ "$l_options" = "failed" ]; then
				echo "- FAILED:"  | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
				echo "- End check - /etc/sysconfig/chronyd not configured correctly" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
		   		return "${XCCDF_RESULT_FAIL:-102}"
			else
				echo "- FAILED:"  | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
				echo "- End check - chrony is not configured correctly" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
		   		return "${XCCDF_RESULT_FAIL:-102}"
			fi
		# If chrony is not installed, no further checking or remediation is required.
		else
			echo -e "- PASS:\n- chrony not installed - no further actions required"  | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
		   	echo "- End check - chrony" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
		   	return "${XCCDF_RESULT_PASS:-101}"
		fi
	}

	fed_chrony_configured_fix()
	{
		echo "- Start remediation - checking chrony configuration" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
		echo "- Remediating chrony configuration" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
		egrep -q "^(\s*)OPTIONS\s*=\s*\"(([^\"]+)?-u\s[^[:space:]\"]+([^\"]+)?|([^\"]+))\"(\s*#.*)?\s*$" /etc/sysconfig/chronyd && sed -ri '/^(\s*)OPTIONS\s*=\s*\"([^\"]*)\"(\s*#.*)?\s*$/ {/^(\s*)OPTIONS\s*=\s*\"[^\"]*-u\s+\S+[^\"]*\"(\s*#.*)?\s*$/! s/^(\s*)OPTIONS\s*=\s*\"([^\"]*)\"(\s*#.*)?\s*$/\1OPTIONS=\"\2 -u chrony\"\3/ }' /etc/sysconfig/chronyd && sed -ri "s/^(\s*)OPTIONS\s*=\s*\"([^\"]+\s+)?-u\s[^[:space:]\"]+(\s+[^\"]+)?\"(\s*#.*)?\s*$/\1OPTIONS=\"\2\-u chrony\3\"\4/" /etc/sysconfig/chronyd || echo "OPTIONS=\"-u chrony\"" >> /etc/sysconfig/chronyd
	}

	fed_chrony_configured_chk
	if [ "$?" = "101" ]; then
		[ -z "$l_test" ] && l_test="passed"
	elif [ "$l_config" = "manual" ]; then
		l_test="manual"
	else
		fed_chrony_configured_fix
		fed_chrony_configured_chk
		if [ "$?" = "101" ]; then
			l_test="remediated"
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
