#!/usr/bin/env bash

###########################################################################
#                                                                         #
# Author: b3nn3tt@hbcomputersecurity.co.uk                                #
# Version: 1.0                                                            #
# Git: https://github.com/b3nn3tt                                         #
#                                                                         #
# File Name:   RHEL9_1.2.4_fed_ensure_repo_gpgcheck_globally_activated.sh #
# Description: Enforces repository gpg check                              #
#                                                                         #
###########################################################################

fed_ensure_repo_gpgcheck_globally_activated()
{
	# Start recommendation entry for verbose log and output to screen
	echo -e "\n**************************************************\n- $(date +%d-%b-%Y' '%T)\n- Start Recommendation \"$RN - $RNA\"" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
	l_test=""

	fed_ensure_repo_gpgcheck_globally_activated_chk()
	{
		l_test1=""
		
		echo -e "- Start check - Ensure repo_gpgcheck is globally activated" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
		
		# Check the global configuration by running the following command and verify that repo_gpgcheck is set to 1:
		if grep -Pq -- '^\h*repo_gpgcheck\h*=\h*1\b' /etc/dnf/dnf.conf; then
			l_test1=passed
		fi

		if [ "$l_test1" = passed ]; then
			echo -e "- MANUAL:\n- repo_gpgcheck is globally activated, but it must be set to false for repositories that do not support it" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			echo -e "- End check - Ensure repo_gpgcheck is globally activated" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			return "${XCCDF_RESULT_PASS:-106}"
		else
			echo -e "- FAILED:\n- repo_gpgcheck is NOT globally activated" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			echo -e "- End check -Ensure repo_gpgcheck is globally activated" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			return "${XCCDF_RESULT_PASS:-102}"
		fi
	}

	fed_ensure_repo_gpgcheck_globally_activated_fix()
	{
		echo -e "- Start remediation - Ensure repo_gpgcheck is globally activated" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"

		if ! grep -Pq -- '^\h*repo_gpgcheck\h*=\h*1\b' /etc/dnf/dnf.conf; then
			if grep -Eq '^\h*repo_gpgcheck\h*=' /etc/dnf/dnf.conf; then
				sed -ri 's/(^\s*repo_gpgcheck\s*)(\s*=\S+)(\s+#.*)?$/\1=1\3/' /etc/dnf/dnf.conf
			else
				sed -ri '/\[main\].*/a repo_gpgcheck=1' /etc/dnf/dnf.conf
			fi
		fi

		echo -e "- End remediation - Ensure repo_gpgcheck is globally activated" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
	}

	fed_ensure_repo_gpgcheck_globally_activated_chk
	if [ "$?" = "106" ] ; then
		[ -z "$l_test" ] && l_test="manual"
	else
        fed_ensure_repo_gpgcheck_globally_activated_fix
		fed_ensure_repo_gpgcheck_globally_activated_chk
		if [ "$?" = "106" ]; then
            [ -z "$l_test" ] && l_test="manual"
        fi
    fi

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
