#!/usr/bin/env bash

##########################################################################
#                                                                        #
# Author: b3nn3tt@hbcomputersecurity.co.uk                               #
# Version: 1.0                                                           #
# Git: https://github.com/b3nn3tt                                        #
#                                                                        #
# File Name:   RHEL9_2.2.11_ensure_http_proxy_server_not_installed.sh    #
# Description: Ensures HTTP Proxy Server is not installed                #
#                                                                        #
##########################################################################

ensure_http_proxy_server_not_installed()
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

	ensure_http_proxy_server_not_installed_chk()
	{
		l_output=""
		l_pkgmgr=""

		echo -e "- Start check - Ensure HTTP Proxy Server is not installed" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"

		# Set package manager information
		if [ -z "$G_PQ" ] || [ -z "$G_PM" ] || [ -z "$G_PR" ]; then
			nix_package_manager_set
			[ "$?" != "101" ] && l_output="- Unable to determine system's package manager"
		fi
	
		# Check to see if avahi-autoipd and avahi are installed.  If not, we pass.
		if [ -z "$l_output" ]; then
			case "$G_PQ" in 
				*rpm*)
					if $G_PQ squid | grep "not installed"; then
						echo -e "- PASSED:\n- squid package not found" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
						echo -e "- End check - Ensure HTTP Proxy Server is not installed" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
						return "${XCCDF_RESULT_PASS:-101}"
					else
						echo -e "- FAILED:\n- squid package installed on the system" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
						echo -e "- End check - Ensure HTTP Proxy Server is not installed" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
						return "${XCCDF_RESULT_PASS:-102}"
					fi
				;;
				*dpkg*)
					if $G_PQ squid; then	
						# If avahi-daemon is not installed, this command returns a "1", which means we go to the else clause and the test passes
						echo -e "- FAILED:\n- squid package installed on the system" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
						echo -e "- End check - Ensure HTTP Proxy Server is not installed" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
						return "${XCCDF_RESULT_PASS:-102}"
					else
						echo -e "- PASSED:\n- squid package not installed" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
						echo -e "- End check - Ensure HTTP Proxy Server is not installed" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
						return "${XCCDF_RESULT_PASS:-101}"
					fi
				;;
			esac
		else
			# If we can't determine the pkg manager, need manual remediation
			l_pkgmgr="$l_output"
			echo -e "- FAILED:\n- $l_output" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			echo -e "- End check - Ensure HTTP Proxy Server is not installed" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			return "${XCCDF_RESULT_PASS:-106}"
		fi
	}	

	ensure_http_proxy_server_not_installed_fix()
	{
		echo -e "- Start remediation - Ensure HTTP Proxy Server is not installed" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"

		case "$G_PQ" in 
			*rpm*)
				echo -e "- Removing package" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
				$G_PR squid
			;;
			*dpkg*)
				echo -e "- Removing package" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
				$G_PR squid
			;;
		esac

		echo -e "- End remediation - Ensure HTTP Proxy Server is not installed" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
	}

	ensure_http_proxy_server_not_installed_chk
	if [ "$?" = "101" ] ; then
		[ -z "$l_test" ] && l_test="passed"
	elif [ -n "$l_pkgmgr" ] ; then
		l_test="manual"
	else
		ensure_http_proxy_server_not_installed_fix
		ensure_http_proxy_server_not_installed_chk
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