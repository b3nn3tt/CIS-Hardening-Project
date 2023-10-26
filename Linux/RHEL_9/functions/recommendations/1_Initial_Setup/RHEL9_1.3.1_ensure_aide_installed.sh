#!/usr/bin/env bash

########################################################################
#                                                                      #
# Author: b3nn3tt@hbcomputersecurity.co.uk                             #
# Version: 1.0                                                         #
# Git: https://github.com/b3nn3tt                                      #
#                                                                      #
# File Name:   RHEL9_1.3.1_ensure_aide_installed.sh                    #
# Description: Ensures AIDE is installed                               #
#                                                                      #
########################################################################

ensure_aide_installed()
{
	echo -e "\n**************************************************\n- $(date +%d-%b-%Y' '%T)\n- Start Recommendation \"$RN - $RNA\"" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
	l_test=""

	nix_package_manager_set()
	{
		echo "- Start - Determine system's package manager " | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
		if command -v rpm 2>/dev/null; then
			echo "- system is rpm based" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			G_PQ="rpm -q"
			command -v yum 2>/dev/null && G_PM="yum" && echo "- system uses yum package manager" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			command -v dnf 2>/dev/null && G_PM="dnf" && echo "- system uses dnf package manager" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			command -v zypper 2>/dev/null && G_PM="zypper" && echo "- system uses zypper package manager" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			G_PR="$G_PM -y remove"
			export G_PQ G_PM G_PR
			echo "- End - Determine system's package manager" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			return "${XCCDF_RESULT_PASS:-101}"
		elif command -v dpkg 2>/dev/null; then
			echo -e "- system is apt based\n- system uses apt package manager" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			G_PQ="dpkg -s"
			G_PM="apt"
			G_PR="$G_PM -y purge"
			export G_PQ G_PM G_PR
			echo "- End - Determine system's package manager" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			return "${XCCDF_RESULT_PASS:-101}"
		else
			echo -e "- FAIL:\n- Unable to determine system's package manager" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			G_PQ="unknown"
			G_PM="unknown"
			export G_PQ G_PM G_PR
			echo "- End - Determine system's package manager" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			return "${XCCDF_RESULT_FAIL:-102}"
		fi
	}

	ensure_aide_installed_chk()
	{
		echo "- Start check - Ensure AIDE is installed" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
		l_output="" l_pkgmgr=""

		# Set package manager information
		if [ -z "$G_PQ" ] || [ -z "$G_PM" ] || [ -z "$G_PR" ]; then
			nix_package_manager_set
			[ "$?" != "101" ] && echo -e "- Unable to determine system's package manager" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
		fi

		# Check to see if aide is installed.  If not, we fail.
		if [ -z "$l_output" ]; then
			case "$G_PQ" in
				*rpm*)
					if $G_PQ aide | grep -Eq 'aide-\S+' 2>&1; then
						echo -e "- PASSED:\n- aide package found" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
						echo -e "- End check - Ensure AIDE is installed" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
						return "${XCCDF_RESULT_PASS:-101}"
					else
						echo -e "- FAILED:\n- aide package NOT installed on the system" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
						echo -e "- End check - Ensure AIDE is installed" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
						return "${XCCDF_RESULT_PASS:-102}"
					fi
				;; 
				*dpkg*)
					if $G_PQ aide > /dev/null 2>&1 && $G_PQ aide-common > /dev/null 2>&1; then
						echo -e "- PASSED:\n- aide packages found" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
						echo -e "- End check - Ensure AIDE is installed" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
						return "${XCCDF_RESULT_PASS:-101}"
					else
						echo -e "- FAILED:\n- aide packages NOT installed on the system" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
						echo -e "- End check - Ensure AIDE is installed" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
						return "${XCCDF_RESULT_PASS:-102}"
					fi
				;;
			esac
		else
			# If we can't determine the pkg manager, need manual remediation
			l_pkgmgr="$l_output"
			echo -e "- FAILED:\n- $l_pkgmgr" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			echo -e "- End check - Ensure LDAP server is not enabled" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			return "${XCCDF_RESULT_PASS:-106}"
		fi
	}

	ensure_aide_installed_fix()
	{
		echo -e "- Start remediation - Ensure AIDE is installed" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"

		case "$G_PQ" in
			*rpm*)
				echo -e "Installing AIDE packages" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
				$G_PM -y install aide
				echo -e "Initializing AIDE, this may take a few minutes" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
				aide --init
				mv -f /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
			;;
			*dpkg*)
				echo -e "- Installation of the AIDE package requires the configuration of an MTA.\n- Install AIDE using the appropriate package manager or manual installation:\n  # apt install aide aide-common" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
				echo -e "- Configure AIDE as appropriate for your environment. Consult the AIDE documentation for options.\n- Run the following commands to initialize AIDE:\n  # aideinit\n  # mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
				l_test="manual"
				return "${XCCDF_RESULT_PASS:-106}"
			;;
		esac
	}

	ensure_aide_installed_chk
   if [ "$?" = "101" ]; then
    	[ -z "$l_test" ] && l_test="passed"
   else
      	ensure_aide_installed_fix
      	if [ "$l_test" != "manual" ]; then
        	ensure_aide_installed_chk
			if [ "$?" = "101" ]; then
				[ "$l_test" != "failed" ] && l_test="remediated"
			else
				l_test="failed"
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
