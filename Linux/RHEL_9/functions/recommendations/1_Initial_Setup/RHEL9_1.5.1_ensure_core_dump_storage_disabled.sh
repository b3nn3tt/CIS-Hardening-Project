#!/usr/bin/env bash

########################################################################
#                                                                      #
# Author: b3nn3tt@hbcomputersecurity.co.uk                             #
# Version: 1.0                                                         #
# Git: https://github.com/b3nn3tt                                      #
#                                                                      #
# File Name:   RHEL9_1.5.1_ensure_core_dump_storage_disabled.sh        #
# Description: Ensures core dump storage is disabled                   #
#                                                                      #
########################################################################

ensure_core_dump_storage_disabled()
{
   	echo -e "\n**************************************************\n- $(date +%d-%b-%Y' '%T)\n- Start Recommendation \"$RN - $RNA\"" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
   	l_test=""

    ensure_core_dump_storage_disabled_chk()
	{
        echo -e "- Start check - Ensure core dump storage is disabled" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
        l_output="" l_output2=""

        if grep -Pq -- '^\h*Storage\h*=\h*none' /etc/systemd/coredump.conf; then
            l_output="$(grep -PHi -- '^\h*Storage\h*=\h*none' /etc/systemd/coredump.conf)"
        else
            l_output2="$(grep -PHi -- '^\h*[#]?\h*Storage' /etc/systemd/coredump.conf)"
        fi       

        if [ -n "$l_output" ]; then
			echo -e "- PASS: Core dump storage IS disabled\n  $l_output" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			echo -e "- End check - Ensure core dump storage is disabled" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			return "${XCCDF_RESULT_PASS:-101}"
		else
			echo -e "- FAIL: Core dump storage is NOT disabled" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
            if [ -n "$l_output2" ]; then
                echo -e "  $l_output2"  | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
            else
                echo -e "  'Storage' entry was NOT found in '/etc/systemd/coredump.conf'"  | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
            fi
			echo -e "- End check - Ensure core dump storage is disabled" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			return "${XCCDF_RESULT_FAIL:-102}"
		fi 
    }

    ensure_core_dump_storage_disabled_fix()
	{
        echo -e "- Start remediation - Ensure core dump storage is disabled" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"

        if [ -n "$l_output2" ]; then
            echo -e "- Updating 'Storage' entry in /etc/systemd/coredump.conf" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
            sed -ri 's/(^\s*[#]?\s*)(Storage\s*=\s*)(\S+\b)(.*)$/\2none\4/' /etc/systemd/coredump.conf
        else
            echo -e "- Inserting 'Storage' entry into /etc/systemd/coredump.conf" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
            echo "Storage=none" >> /etc/systemd/coredump.conf
        fi
      
        echo -e "- End remediation - Ensure core dump storage is disabled" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
    }

    ensure_core_dump_storage_disabled_chk
	if [ "$?" = "101" ]; then
		[ -z "$l_test" ] && l_test="passed"
	else
        if [ "$l_test" != "NA" ]; then
            ensure_core_dump_storage_disabled_fix
            if [ "$l_test" != "manual" ]; then
                ensure_core_dump_storage_disabled_chk
                if [ "$?" = "101" ] ; then
                    [ "$l_test" != "failed" ] && l_test="remediated"
                else
                    l_test="failed"
                fi
            fi
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
