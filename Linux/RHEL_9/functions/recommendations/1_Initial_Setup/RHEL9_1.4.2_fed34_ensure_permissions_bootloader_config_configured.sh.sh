#!/usr/bin/env bash

#####################################################################################
#                                                                                   #
# Author: b3nn3tt@hbcomputersecurity.co.uk                                          #
# Version: 1.0                                                                      #
# Git: https://github.com/b3nn3tt                                                   #
#                                                                                   #
# File Name:   RHEL9_1.4.2_fed34_ensure_permissions_bootloader_config_configured.sh #
# Description: Ensures permissions on bootloader config are configured              #
#                                                                                   #
#####################################################################################

fed34_ensure_permissions_bootloader_config_configured()
{
	# Start recommendation entriey for verbose log and output to screen
	echo -e "\n**************************************************\n- $(date +%d-%b-%Y' '%T)\n- Start Recommendation \"$RN - $RNA\"" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
	l_test=""
	
	fed34_ensure_permissions_bootloader_config_configured_chk()
	{
		echo -e "- Start check - Ensure permissions on bootloader config are configured" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
        l_output="" l_output2=""

        for file in "/boot/grub2/grub.cfg" "/boot/grub2/grubenv" "/boot/grub2/user.cfg"; do
            if [ -f "$file" ]; then
                if stat -c "%a" "$file" | grep -Pq '^\h*[0-7]00$'; then
                    l_output="$l_output\n  Permissions on \"$file\" are \"$(stat -c "%a" "$file")\""
                else
                    l_output2="$l_output2\n  Permissions on \"$file\" are \"$(stat -c "%a" "$file")\""
                fi

                if stat -c "%u:%g" "$file" | grep -Pq '^\h*0:0$'; then
                    l_output="  $l_output\n\"$file\" is owned by \"$(stat -c "%U" "$file")\" and belongs to group \"$(stat -c "%G" "$file")\""
                else
                    l_output2="  $l_output2\n\"$file\" is owned by \"$(stat -c "%U" "$file")\" and belongs to group \"$(stat -c "%G" "$file")\""
                fi
            fi
        done

        if [ -z "$l_output2" ]; then
            echo -e "- PASSED:\n$l_output" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
            echo -e "- End check - Ensure permissions on bootloader config are configured" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
            return "${XCCDF_RESULT_PASS:-101}"
        else
            echo -e "- FAILED:\n- Failing Values:\n$l_output2" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
            if [ -n "$l_output" ]; then
                echo -e "- Passing Values:\n$l_output" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
            fi
            echo -e "- End check - Ensure permissions on bootloader config are configured" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
            return "${XCCDF_RESULT_PASS:-102}"
        fi
	}
	
	fed34_ensure_permissions_bootloader_config_configured_fix()
	{
		echo -e "- Start remediation - Ensure permissions on bootloader config are configured" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"

		if [ -f "/boot/grub2/user.cfg" ]; then
            echo -e "- Setting permissions on /boot/grub2/user.cfg" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			chown root:root /boot/grub2/user.cfg
			chmod og-rwx /boot/grub2/user.cfg      
		fi

		if [ -f "/boot/grub2/grubenv" ]; then
            echo -e "- Setting permissions on /boot/grub2/grubenv" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			chown root:root "/boot/grub2/grubenv"
			chmod og-rwx "/boot/grub2/grubenv"  
		fi

		if [ -f "/boot/grub2/grub.cfg" ]; then
            echo -e "- Setting permissions on /boot/grub2/grub.cfg" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			chown root:root "/boot/grub2/grub.cfg"
			chmod og-rwx "/boot/grub2/grub.cfg"
		fi

		echo  -e "- End remediation - Ensure permissions on bootloader config are configured" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
	}
	
	fed34_ensure_permissions_bootloader_config_configured_chk
	if [ "$?" = "101" ]; then
		[ -z "$l_test" ] && l_test="passed"
	else
		fed34_ensure_permissions_bootloader_config_configured_fix
		fed34_ensure_permissions_bootloader_config_configured_chk
		if [ "$?" = "101" ] ; then
			[ "$l_test" != "failed" ] && l_test="remediated"
		else
			l_test="failed"
		fi
	fi
	
	# Set return code and return
	case "$l_test" in
		passed)
			echo "Recommendation \"$RNA\" No remediation required" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			return "${XCCDF_RESULT_PASS:-101}"
			;;
		remediated)
			echo "Recommendation \"$RNA\" successfully remediated" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			return "${XCCDF_RESULT_PASS:-103}"
			;;
		manual)
			echo "Recommendation \"$RNA\" requires manual remediation" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			return "${XCCDF_RESULT_FAIL:-106}"
			;;
		NA)
			echo "Recommendation \"$RNA\" Something went wrong - Recommendation is non applicable" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			return "${XCCDF_RESULT_PASS:-104}"
			;;
		*)
			echo "Recommendation \"$RNA\" remediation failed" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			return "${XCCDF_RESULT_FAIL:-102}"
			;;
	esac
}
