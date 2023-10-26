#!/usr/bin/env bash

########################################################################
#                                                                      #
# Author: b3nn3tt@hbcomputersecurity.co.uk                             #
# Version: 1.0                                                         #
# Git: https://github.com/b3nn3tt                                      #
#                                                                      #
# File Name:   RHEL9_1.4.1_fed_ensure_bootloader_password_set.sh       #
# Description: Ensures bootloader password is set                      #
#                                                                      #
########################################################################

fed_ensure_bootloader_password_set()
{
   echo -e "\n**************************************************\n- $(date +%d-%b-%Y' '%T)\n- Start Recommendation \"$RN - $RNA\"" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
   test=""
   
   fed_ensure_bootloader_password_set_chk()
	{
        echo -e "- Start check - Ensure bootloader password is set" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
        l_tst1="" l_tst2="" l_output="" 
      
        l_efidir=$(find /boot/efi/EFI/* -type d -not -name 'BOOT') 
        l_gbdir=$(find /boot -maxdepth 1 -type d -name 'grub*') 
      
        if [ -f "$l_efidir"/grub.cfg ]; then 
            l_grubdir="$l_efidir" && l_grubfile="$l_efidir/grub.cfg" 
        elif [ -f "$l_gbdir"/grub.cfg ]; then 
            l_grubdir="$l_gbdir" && l_grubfile="$l_gbdir/grub.cfg" 
        fi
        
        l_userfile="$l_grubdir/user.cfg" 
        
        [ -f "$l_userfile" ] && grep -Pq '^\h*GRUB2_PASSWORD\h*=\h*.+$' "$l_userfile" && l_output="- bootloader password set in \"$l_userfile\"" 
        
        if [ -z "$l_output" ] && [ -f "$l_grubfile" ]; then 
            grep -Piq '^\h*set\h+superusers\h*=\h*"?[^"\n\r]+"?(\h+.*)?$' "$l_grubfile" && l_tst1=pass 
            grep -Piq '^\h*password\h+\H+\h+.+$' "$l_grubfile" && l_tst2=pass 
            
            [ "$l_tst1" = pass ] && [ "$l_tst2" = pass ] && l_output="- bootloader password set in \"$l_grubfile\"" 
        fi 
      
      if [ -n "$l_output" ]; then
			echo -e "- PASS:\n$l_output" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			echo -e "- End check - Ensure bootloader password is set" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			return "${XCCDF_RESULT_PASS:-101}"
		else
			echo -e "- FAIL:\n- bootloader password is NOT set" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			echo -e "- End check - Ensure bootloader password is set" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			return "${XCCDF_RESULT_FAIL:-102}"
		fi 
   }
   
   fed_ensure_bootloader_password_set_fix()
	{
   
      echo -e "- Start remediation - Ensure bootloader password is set" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"      
      
      echo -e "- Set a bootloader password.\n- For newer grub2 based systems (Release 7.2 and newer), create an encrypted password with grub2-setpassword :\n    # grub2-setpassword\n    Enter password: <password>\n    Confirm password: <password>" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"   
      test="manual"
      
      echo -e "- End remediation - Ensure bootloader password is set" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
   }
   
   fed_ensure_bootloader_password_set_chk
	if [ "$?" = "101" ]; then
		[ -z "$test" ] && test="passed"
	else
        if [ "$test" != "NA" ]; then
            fed_ensure_bootloader_password_set_fix
            if [ "$test" != "manual" ]; then
                fed_ensure_bootloader_password_set_chk
            fi
        fi
	fi
	
	# Set return code, end recommendation entry in verbose log, and return
	case "$test" in
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
