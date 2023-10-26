#!/usr/bin/env bash

#################################################################################
#                                                                               #
# Author: b3nn3tt@hbcomputersecurity.co.uk                                      #
# Version: 1.0                                                                  #
# Git: https://github.com/b3nn3tt                                               #
#                                                                               #
# File Name:   RHEL9_1.5.3_ensure_address_space_layout_randomization_enabled.sh #
# Description: Ensures address space layout randomization (ASLR) is enabled     #
#                                                                               #
#################################################################################

ensure_address_space_layout_randomization_enabled()
{
	# Start recommendation entry for verbose log and output to screen
	echo -e "\n**************************************************\n- $(date +%d-%b-%Y' '%T)\n- Start Recommendation \"$RN - $RNA\"" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
	l_test=""

	ensure_address_space_layout_randomization_enabled_chk()
	{
		echo -e "- Start check - Ensure address space layout randomization (ASLR) is enabled" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
		
		krp="" pafile="" fafile=""
		
		kpname="kernel.randomize_va_space" 
		kpvalue="2"
		searchloc="/run/sysctl.d/*.conf /etc/sysctl.d/*.conf /usr/local/lib/sysctl.d/*.conf /usr/lib/sysctl.d/*.conf /lib/sysctl.d/*.conf /etc/sysctl.conf"
		
		krp="$(sysctl "$kpname" | awk -F= '{print $2}' | xargs)"
		pafile="$(grep -Psl -- "^\h*$kpname\h*=\h*$kpvalue\b\h*(#.*)?$" $searchloc)"
		fafile="$(grep -s -- "^\s*$kpname" $searchloc | grep -Pv -- "\h*=\h*$kpvalue\b\h*" | awk -F: '{print $1}')"
		
		if [ "$krp" = "$kpvalue" ] && [ -n "$pafile" ] && [ -z "$fafile" ]; then
			echo -e "\nPASS:\n\"$kpname\" is set to \"$kpvalue\" in the running configuration and in \"$pafile\"" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			echo -e "- End check - Ensure address space layout randomization (ASLR) is enabled" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			return "${XCCDF_RESULT_PASS:-101}"
		else
			echo -e "\nFAIL: " | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			[ "$krp" != "$kpvalue" ] && echo -e "\"$kpname\" is set to \"$krp\" in the running configuration\n" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			[ -n "$fafile" ] && echo -e "\n\"$kpname\" is set incorrectly in \"$fafile\"" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			[ -z "$pafile" ] && echo -e "\n\"$kpname = $kpvalue\" is not set in a kernel parameter configuration file\n" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			echo -e "- End check - Ensure address space layout randomization (ASLR) is enabled" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			return "${XCCDF_RESULT_PASS:-102}"
		fi
	}

	ensure_address_space_layout_randomization_enabled_fix()
	{
		echo -e "- Start remediation - Ensure GPG keys are configured" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"

		# If the parameter is correctly set in the file(s), set the active kernel parameter
		if grep -Eqs '^\s*kernel.randomize_va_space\s*=\s*2\b' /etc/sysctl.conf /etc/sysctl.d/*; then
			echo -e "- Writing kernel.randomize_va_space to sysctl" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			sysctl -w kernel.randomize_va_space=2
		else
			# If the parameter is in the file(s) but not correctly set, fix it in the file(s)
			grep -q 'kernel.randomize_va_space' /etc/sysctl.conf && sed -ri 's/^(.*)(kernel\.randomize_va_space\s*=\s*\S+\s*)(\s+#.*)?$/kernel.randomize_va_space = 2\3/' /etc/sysctl.conf
			for file in /etc/sysctl.d/*; do
				grep -qs 'kernel.randomize_va_space' "$file" && sed -ri 's/^(.*)(kernel\.randomize_va_space\s*=\s*\S+\s*)(\s+#.*)?$/kernel.randomize_va_space = 2\3/' "$file" && echo -e "- Updating kernel.randomize_va_space in $file" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			done
			# If the parameter does not exist in the file(s), create a new file with it
			if ! grep -Eqs '^\s*kernel.randomize_va_space\s*=\s*2\b' /etc/sysctl.conf /etc/sysctl.d/*; then
				echo -e "- Adding kernel.randomize_va_space to /etc/sysctl.d/cis_sysctl.conf" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
				echo "kernel.randomize_va_space = 2" >> /etc/sysctl.d/cis_sysctl.conf
			fi
			# If we had to add or modify the parameter in a file(s), we need to set the active kernel parameter
			sysctl -w kernel.randomize_va_space=2
		fi

		echo -e "- End remediation - Ensure GPG keys are configured" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
	}

	ensure_address_space_layout_randomization_enabled_chk
	if [ "$?" = "101" ]; then
		[ -z "$l_test" ] && l_test="passed"
	else
		ensure_address_space_layout_randomization_enabled_fix
		ensure_address_space_layout_randomization_enabled_chk
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
