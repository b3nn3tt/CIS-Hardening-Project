#!/usr/bin/env bash

#################################################################################
#                                                                               #
# Author: b3nn3tt@hbcomputersecurity.co.uk                                      #
# Version: 1.0                                                                  #
# Git: https://github.com/b3nn3tt                                               #
#                                                                               #
# File Name:   RHEL9_2.2.15_ensure_mail_transfer_agent_configured_local_only.sh #
# Description: Ensures mail transfer agent is configured for local-only mode    #
#                                                                               #
#################################################################################

ensure_mail_transfer_agent_configured_local_only()
{
	# Start recommendation entry for verbose log and output to screen
	echo -e "\n**************************************************\n- $(date +%d-%b-%Y' '%T)\n- Start Recommendation \"$RN - $RNA\"" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
	
	ensure_mail_transfer_agent_configured_local_only_chk()
	{
		# Determine if postfix is enabled.  If it is not, then manual remediation is required.
		if systemctl is-enabled postfix.service | egrep -qi "enabled|disabled"; then
			# Verify that the MTA is not listening on any non-loopback address
			l_test=""
			l_test1=""
		
			# If something is returned, the test fails
			if ss -lntu | grep -E ':25\s' | grep -Evq '\s(127.0.0.1|\[?::1\]?):25\s'; then
				l_test1="failed"
			else
				l_test1="passed"
			fi

			if [ "$l_test1" = "passed"  ]; then
				echo -e "- PASSED:\n- mail transfer agent is configured for local-only mode" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
				echo -e "- End check - mail transfer agent" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
				return "${XCCDF_RESULT_PASS:-101}"
			elif [ "$l_test1" = "failed" ]; then
				echo -e "- FAILED:\n- mail transfer agent is listening for remote connections" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
				echo -e "- End check - mail transfer agent" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
				return "${XCCDF_RESULT_PASS:-102}"
			else
				l_test="manual"
				echo -e "- Remediation required:\n- Could not determine if mail transfer agent is configured for local-only mode" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
				return "${XCCDF_RESULT_PASS:-106}"
			fi
		else
			l_test="manual"
			echo -e "- Remediation required:\n- Could not determine if mail transfer agent is configured for local-only mode" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			return "${XCCDF_RESULT_PASS:-106}"
		fi
	}

	ensure_mail_transfer_agent_configured_local_only_fix()
	{
		if [ "$l_test1" = "failed" ]; then
			# If "inet_interfaces" line exists in file, change its value to loopback-only.
			if grep -Eq '^\s*inet_interfaces\s*=\s*[^#]*\s*' /etc/postfix/main.cf; then
				sed -ri 's/(^\s*inet_interfaces\s*=\s*)([^#]*\s*)?(#.*)?/\1loopback-only\3/' /etc/postfix/main.cf
			# If "inet_interfaces" line does not exist in file, append it to the RECEIVING MAIL section.
			else
				sed -ri '/^#\s*RECEIVING MAIL\s*.*$/a inet_interfaces = loopback-only' /etc/postfix/main.cf
			fi
			systemctl restart postfix
		fi
	}
	
	ensure_mail_transfer_agent_configured_local_only_chk
	if [ "$?" = "101" ]; then
		[ -z "$l_test" ] && l_test="passed"
	elif [ "$l_test" = "manual" ]; then
		:
	else
		ensure_mail_transfer_agent_configured_local_only_fix
		ensure_mail_transfer_agent_configured_local_only_chk
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