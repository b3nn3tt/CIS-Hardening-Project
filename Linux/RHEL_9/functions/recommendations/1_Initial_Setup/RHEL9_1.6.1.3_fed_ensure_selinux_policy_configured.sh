#!/usr/bin/env bash

########################################################################
#                                                                      #
# Author: b3nn3tt@hbcomputersecurity.co.uk                             #
# Version: 1.0                                                         #
# Git: https://github.com/b3nn3tt                                      #
#                                                                      #
# File Name:   RHEL9_1.6.1.3_fed_ensure_selinux_policy_configured.sh   #
# Description: Ensures SELinux policy is configured                    #
#                                                                      #
########################################################################

fed_ensure_selinux_policy_configured()
{
	# Start recommendation entry for verbose log and output to screen
	echo -e "\n**************************************************\n- $(date +%d-%b-%Y' '%T)\n- Start Recommendation \"$RN - $RNA\"" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
	l_test=""	

	fed_ensure_selinux_policy_configured_chk()
	{
		echo "- Start check - Ensure SELinux policy is configured" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"

		# Determine if SELinux is explicitly disabled.
		if ! grep -Eqs '^\s*SELINUX=disabled\b' /etc/selinux/config; then
			echo -e "- SELinux appears to be enabled in /etc/selinux/config" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			# Determine if the following commands output either "targeted" or "mls".
			if grep -Eqs '^\s*SELINUXTYPE=(targeted|mls)\b' /etc/selinux/config; then
					if [ "$l_test" != "remediated" ]; then
							if sestatus | grep -Eq 'Loaded\s+policy\s+name:\s+(targeted|mls)'; then
								echo -e "- PASSED:\n- SELinux policy set on the system" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
								echo -e "- End check - SELinux policy" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
								return "${XCCDF_RESULT_PASS:-101}"
							else
								echo -e "- FAILED:\n- SELinux policy not set correctly" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
								echo -e "- End check - SELinux policy" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
								return "${XCCDF_RESULT_PASS:-102}"
							fi
					else
							echo -e "- PASSED:\n- SELinux policy set on the system" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
							echo -e "- End check - SELinux policy" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
							return "${XCCDF_RESULT_PASS:-101}"
					fi
			else
				echo -e "- FAILED:\n- SELinux policy not set correctly" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
				echo -e "- End check - Ensure SELinux policy is configured" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
				return "${XCCDF_RESULT_PASS:-102}"
			fi
		else
			echo -e "- SELinux appears to be disabled in /etc/selinux/config" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			l_test="manual"
			return "${XCCDF_RESULT_PASS:-106}"
		fi
	}

	fed_ensure_selinux_policy_configured_fix()
	{
		echo "- Start remediation - Ensure SELinux policy is configured" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"

		# If SELINUXTYPE is set to some value, comment that line out and append a line setting SELINUXTYPE to "targeted".  Else append a line setting SELINUXTYPE to "targeted"
		if grep -Eqs '^\s*SELINUXTYPE=\S+\b' /etc/selinux/config; then
			sed -ri 's/^\s*SELINUXTYPE=\S+\b.*$/# &/' /etc/selinux/config
			echo "SELINUXTYPE=targeted" >> /etc/selinux/config && l_test=remediated
		else
			echo "SELINUXTYPE=targeted" >> /etc/selinux/config && l_test=remediated
		fi
		G_REBOOT_REQUIRED="yes"

		echo "- End remediation - Ensure SELinux policy is configured" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
	}

	fed_ensure_selinux_policy_configured_chk
	if [ "$?" = "101" ]; then
		[ -z "$l_test" ] && l_test="passed"
	elif [ "$l_test" = "manual" ]; then
		l_test="manual"
	else
		fed_ensure_selinux_policy_configured_fix
		fed_ensure_selinux_policy_configured_chk
		if [ "$?" = "101" ]; then
			[ "$l_test" != "failed" ] && l_test=remediated
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
