#!/usr/bin/env bash

##############################################################################
#                                                                            #
# Author: b3nn3tt@hbcomputersecurity.co.uk                                   #
# Version: 1.0                                                               #
# Git: https://github.com/b3nn3tt                                            #
#                                                                            #
# File Name:   RHEL9_2.2.18_ensure_rsync_service_not_enabled.sh              #
# Description: Ensures rsync service is either not installed or masked       #
#                                                                            #
##############################################################################

ensure_rsync_service_not_enabled()
{
    nix_package_manager_set()
	{
		echo -e "- Start - Determine system's package manager " | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"

		if command -v rpm 2>/dev/null; then
			echo -e "- system is rpm based" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			G_PQ="rpm -q"
			command -v yum 2>/dev/null && G_PM="yum" && echo "- system uses yum package manager" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			command -v dnf 2>/dev/null && G_PM="dnf" && echo "- system uses dnf package manager" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			command -v zypper 2>/dev/null && G_PM="zypper" && echo "- system uses zypper package manager" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			G_PR="$G_PM -y remove"
			export G_PQ G_PM G_PR
			echo -e "- End - Determine system's package manager" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			return "${XCCDF_RESULT_PASS:-101}"
		elif command -v dpkg 2>/dev/null; then
			echo -e "- system is apt based\n- system uses apt package manager" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			G_PQ="dpkg -s"
			G_PM="apt"
			G_PR="$G_PM -y purge"
			export G_PQ G_PM G_PR
			echo -e "- End - Determine system's package manager" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			return "${XCCDF_RESULT_PASS:-101}"
		else
			echo -e "- FAIL:\n- Unable to determine system's package manager" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			G_PQ="unknown"
			G_PM="unknown"
			export G_PQ G_PM G_PR
			echo -e "- End - Determine system's package manager" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			return "${XCCDF_RESULT_FAIL:-102}"
		fi
	}

	# Start recommendation entry for verbose log and output to screen
	echo -e "\n**************************************************\n- $(date +%d-%b-%Y' '%T)\n- Start Recommendation \"$RN - $RNA\"" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
	l_test=""

	ensure_rsync_service_not_enabled_chk()
	{
        l_output="" l_pkgmgr=""

        echo -e "- Start check - Ensure rsync service is either not installed or is masked" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"

        # Set package manager information
		if [ -z "$G_PQ" ] || [ -z "$G_PM" ] || [ -z "$G_PR" ]; then
			nix_package_manager_set
			[ "$?" != "101" ] && l_output="- Unable to determine system's package manager"
		fi

        # Check to see if rsync package are installed.  If not, we pass.
		if [ -z "$l_output" ]; then
			case "$G_PQ" in 
				*rpm*)
					### if $G_PQ rsync-daemon > /dev/null 2>&1 && ! systemctl is-enabled rsyncd | grep -Pq -- '(masked|disabled)' && systemctl is-active rsyncd | grep -Pq -- '(inactive)'; then
					if $G_PQ rsync-daemon > /dev/null 2>&1 && ! systemctl is-enabled rsyncd | grep -Pq -- '(masked)'; then	
						# If rsync is not installed, this command returns a "1", which means we go to the else clause and the test passes
						echo -e "- FAILED:\n- rsync-daemon package IS installed and NOT masked on the system" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
						echo -e "- End check - Ensure rsync service is either not installed or is masked" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
						return "${XCCDF_RESULT_PASS:-102}"
					else
						echo -e "- PASSED:\n- rsync-daemon package not installed or is masked" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
						echo -e "- End check - Ensure rsync service is either not installed or is masked" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
						return "${XCCDF_RESULT_PASS:-101}"
					fi
				;;
				*dpkg*)
					if $G_PQ rsync > /dev/null 2>&1 && ! ( systemctl is-enabled rsync | grep -Pq -- '(masked)' && systemctl is-active rsync | grep -Pq -- '(inactive)'); then
						# If package is not installed, this command returns a "1", which means we go to the else clause and the test passes
						echo -e "- FAILED:\n- rsync package installed on the system" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
						echo -e "- End check - Ensure rsync service is either not installed or is masked" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
						return "${XCCDF_RESULT_PASS:-102}"
					else
						echo -e "- PASSED:\n- rsync package not installed or is masked" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
						echo -e "- End check - Ensure rsync service is either not installed or is masked" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
						return "${XCCDF_RESULT_PASS:-101}"
					fi
				;;
			esac
		else
			# If we can't determine the pkg manager, need manual remediation
			l_pkgmgr="$l_output"
			echo -e "- FAILED:\n- $l_output" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			echo -e "- End check - Ensure rsync service is either not installed or is masked" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			return "${XCCDF_RESULT_PASS:-106}"
		fi
	}

	ensure_rsync_service_not_enabled_fix()
	{
		echo "- Start remediation - Ensure rsync service is either not installed or is masked" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"

        case "$G_PQ" in 
            *rpm*)
                echo -e "- Stopping rsyncd" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
                systemctl stop rsyncd
                echo -e "- Masking rsyncd" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
                systemctl --now mask rsyncd
            ;;
            *dpkg*)
                echo -e "- Stopping rsync" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
                systemctl stop rsync
                echo -e "- Masking rsync" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
                systemctl mask rsync
            ;;
        esac

        echo "- Start remediation - Ensure rsync service is either not installed or is masked" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
	}

	ensure_rsync_service_not_enabled_chk
	if [ "$?" = "101" ] ; then
		[ -z "$l_test" ] && l_test="passed"
	elif [ -n "$l_pkgmgr" ] ; then
		l_test="manual"
	else
		ensure_rsync_service_not_enabled_fix
		ensure_rsync_service_not_enabled_chk
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