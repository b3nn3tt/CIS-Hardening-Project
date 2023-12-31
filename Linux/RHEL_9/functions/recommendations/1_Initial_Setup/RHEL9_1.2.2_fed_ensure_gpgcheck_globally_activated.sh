#!/usr/bin/env bash

########################################################################
#                                                                      #
# Author: b3nn3tt@hbcomputersecurity.co.uk                             #
# Version: 1.0                                                         #
# Git: https://github.com/b3nn3tt                                      #
#                                                                      #
# File Name:   RHEL9_1.2.2_fed_ensure_gpgcheck_globally_activated.sh   #
# Description: Ensures gpgcheck is globally activated                  #
#                                                                      #
########################################################################

fed_ensure_gpgcheck_globally_activated()
{
	# Start recommendation entry for verbose log and output to screen
	echo -e "\n**************************************************\n- $(date +%d-%b-%Y' '%T)\n- Start Recommendation \"$RN - $RNA\"" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
	l_test=""

	fed_ensure_gpgcheck_globally_activated_chk()
	{
		l_test1=""
		l_test2=""
		
		echo -e "- Start check - Ensure gpgcheck is globally activated" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
		
		# Check the global configuration by running the following command and verify that gpgcheck is set to 1:
		if grep -Pq -- '^\h*gpgcheck\h*=\h*1\b' /etc/dnf/dnf.conf; then
			l_test1=passed
		fi

		# The configuration in /etc/yum.repos.d/ takes precedence over the global configuration, so we will run the following command and verify that all instances 
		# of entries starting with gpgcheck are set to "1".  
		if ! grep -Pq -- "^gpgcheck\h*=\h*[^1].*\h*$" /etc/yum.repos.d/*; then
			l_test2=passed
		fi

		if [ "$l_test1" = passed ] && [ "$l_test2" = passed ]; then
			echo -e "- PASSED:\n- gpgcheck is globally activated" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			echo -e "- End check - Ensure gpgcheck is globally activated" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			return "${XCCDF_RESULT_PASS:-101}"
		else
			echo -e "- FAILED:\n- gpgcheck is NOT globally activated" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			echo -e "- End check -Ensure gpgcheck is globally activated" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			return "${XCCDF_RESULT_PASS:-102}"
		fi
	}

	fed_ensure_gpgcheck_globally_activated_fix()
	{
		echo -e "- Start remediation - Ensure gpgcheck is globally activated" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"

		if ! grep -Pq -- '^\h*gpgcheck\h*=\h*1\b' /etc/dnf/dnf.conf; then
			if grep -Eq '^\h*gpgcheck\h*=' /etc/dnf/dnf.conf; then
				sed -ri 's/(^\s*gpgcheck\s*)(\s*=\S+)(\s+#.*)?$/\1=1\3/' /etc/dnf/dnf.conf
			else
				sed -ri '/\[main\].*/a gpgcheck=1' /etc/dnf/dnf.conf
			fi
		fi

		find /etc/yum.repos.d/ -name "*.repo" -exec echo "Checking:" {} \; -exec sed -ri 's/(^\s*gpgcheck\s*)(\s*=\s*\S+)(\s*#.*)?$/\1=1\3/' {} \;

		echo -e "- End remediation - Ensure gpgcheck is globally activated" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
	}

	fed_ensure_gpgcheck_globally_activated_chk
	if [ "$?" = "101" ] ; then
		[ -z "$l_test" ] && l_test="passed"
	else
        fed_ensure_gpgcheck_globally_activated_fix
		fed_ensure_gpgcheck_globally_activated_chk
		if [ "$?" = "101" ]; then
            [ -z "$l_test" ] && l_test="remediated"
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
