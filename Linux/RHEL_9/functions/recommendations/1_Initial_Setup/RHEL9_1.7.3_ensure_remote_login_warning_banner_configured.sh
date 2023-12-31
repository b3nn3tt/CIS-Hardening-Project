#!/usr/bin/env bash


#############################################################################
#                                                                           #
# Author: b3nn3tt@hbcomputersecurity.co.uk                                  #
# Version: 1.0                                                              #
# Git: https://github.com/b3nn3tt                                           #
#                                                                           #
# File Name:   RHEL9_1.7.3_ensure_remote_login_warning_banner_configured.sh #
# Description: Ensures remote login warning banner is configured properly   #
#                                                                           #
#############################################################################

ensure_remote_login_warning_banner_configured()
{
	echo -e "\n**************************************************\n- $(date +%d-%b-%Y' '%T)\n- Start Recommendation \"$RN - $RNA\"" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
	l_test=""
	
	ensure_remote_login_warning_banner_configured_chk()
	{
		echo -e "- Start check - Ensure remote login warning banner is configured properly" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"

		if [ -e /etc/issue.net ]; then
			if grep -E -i "(\\\v|\\\r|\\\m|\\\s|$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/"//g'))" /etc/issue.net > /dev/null; then
				# print the reason why we are failing
				echo -e "- FAILED:\n- /etc/issue.net contains $(grep -E -i "(\\\v|\\\r|\\\m|\\\s|$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/"//g'))" /etc/issue.net)"  | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
				echo -e "- End check - Ensure remote login warning banner is configured properly" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
				return "${XCCDF_RESULT_FAIL:-102}"
			else
				echo -e "- PASS:\n- /etc/issue.net is configured properly"  | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
				echo -e "- End check - Ensure remote login warning banner is configured properly" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
				return "${XCCDF_RESULT_PASS:-101}"
			fi
		else
			echo -e "- FAIL:\n- /etc/issue.net does NOT exist"  | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			echo -e "- End check - Ensure remote login warning banner is configured properly" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			return "${XCCDF_RESULT_PASS:-102}"
		fi
	}

	ensure_remote_login_warning_banner_configured_fix()
	{
		echo -e "- Start remediation - Ensure remote login warning banner is configured properly" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"

		echo -e "AUTHORIZED ACCESS ONLY\n\nBy accessing this system, you acknowledge that:\n\n1. This system is for authorised use only. Unauthorised access, use, disruption, modification, or destruction is strictly prohibited and may be punishable under the Computer Misuse Act 1990.\n\n2. All activities on this system may be monitored, logged, and subject to audit. Any unauthorized activities are subject to investigation and potential legal action.\n\n3. All data, including personal data, processed by this system is handled in accordance with data protection laws, including the Data Protection Act 2018 and the General Data Protection Regulation (GDPR). If you are not the intended recipient of this information, you must not process, distribute, or act upon it.\n\n4. If you do not understand these terms or the legal obligations associated with access, you should exit now." > /etc/issue.net

		echo -e "- End remediation - Ensure remote login warning banner is configured properly" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"

	}

	ensure_remote_login_warning_banner_configured_chk
	if [ "$?" = "101" ] ; then
		[ -z "$l_test" ] && l_test="passed"
	else
		ensure_remote_login_warning_banner_configured_fix
		ensure_remote_login_warning_banner_configured_chk
		if [ "$?" = "101" ] ; then
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
