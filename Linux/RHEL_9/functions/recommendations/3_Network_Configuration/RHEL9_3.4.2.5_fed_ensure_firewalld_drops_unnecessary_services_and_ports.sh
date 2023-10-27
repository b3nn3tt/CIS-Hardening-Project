#!/usr/bin/env bash

###########################################################################################
#                                                                                         #
# Author: b3nn3tt@hbcomputersecurity.co.uk                                                #
# Version: 1.0                                                                            #
# Git: https://github.com/b3nn3tt                                                         #
#                                                                                         #
# File Name:   RHEL9_3.4.2.5_fed_ensure_firewalld_drops_unnecessary_services_and_ports.sh #
# Description: Ensures firewalld drops unnecessary services and ports                     #
#                                                                                         #
###########################################################################################

fed_ensure_firewalld_drops_unnecessary_services_and_ports()
{
	# Start recommendation entry for verbose log and output to screen
	echo -e "\n**************************************************\n- $(date +%d-%b-%Y' '%T)\n- Start Recommendation \"$RN - $RNA\"" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
	test=""
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
	
	fed_firewall_chk()
	{
		echo "- Start - Check to determine Firewall in use on the system" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
		# Firewall Options:
		# Firewalld               - FWd
		# NFTables                - NFt
		# IPTables                - IPt
		# No firewall installed   - FNi
		# Multiple firewalls used - MFu
		# Firewall Unknown        - UKn	
		G_FWIN=""

		# Check is package manager is defined
		if [ -z "$G_PQ" ] || [ -z "$G_PM" ] || [ -z "$G_PR" ]; then
			nix_package_manager_set
		fi

		# Check FirewallD status
		echo "- Start - Determine FirewallD status" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
		l_fwds=""
		if ! $G_PQ firewalld >/dev/null; then
			l_fwds="nnn"
			echo "- FirewallD is not install on the system" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
		else
			echo "- FirewallD is installed on the system"  | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			if systemctl is-enabled firewalld | grep -q 'enabled' && systemctl is-active firewalld | grep -q 'active'; then
				l_fwds="yyy"
				echo "- FirewallD is installed on the system, is enabled, and is active" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			elif systemctl is-enabled firewalld | grep -q 'enabled' && ! systemctl is-active firewalld | grep -q 'active'; then
				l_fwds="yyn"
				echo "- FirewallD is installed on the system, is enabled, but is not active" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			elif ! systemctl is-enabled firewalld | grep -q 'enabled' && systemctl is-active firewalld | grep -q 'active'; then
				l_fwds="yny"
				echo "- FirewallD is installed on the system, is disabled, but is active" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			else
				l_fwds="ynn"
				echo "- FirewallD is installed on the system, is disabled, and is not active"  | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			fi
		fi	
		echo "- End - Determine FirewallD status" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
		
		# Check NFTables status
		echo "- Start - Determine NFTables status" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
		l_nfts=""
		l_nftr=""
		if ! $G_PQ nftables >/dev/null; then
			l_nfts="nnn"
			echo "- NFTables is not install on the system" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
		else
			echo "- NFTables is installed on the system"  | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			if systemctl is-enabled nftables | grep -q 'enabled' && systemctl is-active nftables | grep -q 'active'; then
				l_nfts="yyy"
				echo "- NFTables is installed on the system, is enabled, and is active" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			elif systemctl is-enabled nftables | grep -q 'enabled' && ! systemctl is-active nftables | grep -q 'active'; then
				l_nfts="yyn"
				echo "- NFTables is installed on the system, is enabled, but is not active" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			elif ! systemctl is-enabled nftables | grep -q 'enabled' && systemctl is-active nftables | grep -q 'active'; then
				l_nfts="yny"
				echo "- NFTables is installed on the system, is disabled, but is active" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			else
				l_nfts="ynn"
				echo "- NFTables is installed on the system, is disabled, and is not active"  | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			fi
			if [ -n "$(nft list ruleset)" ]; then
				l_nftr="y"
				echo "- NFTables rules exist on the system" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			fi
		fi
		echo "- End - Determine NFTables status" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
		
		# Check IPTables status
		echo "- Start - Determine IPTables status" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
		l_ipts=""
		l_iptr=""
		if ! $G_PQ iptables >/dev/null; then
			l_ipts="nnn"
			echo "- IPTables is not install on the system" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
		else
			echo "- IPTables is installed on the system" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			if iptables -n -L -v --line-numbers | grep -Eq '^[0-9]+'; then
				l_iptr="y"
				echo "- IPTables rules exist on the system" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			fi
			if $G_PQ iptables-services >/dev/null; then
				echo "- IPTables service package \"iptables-services\" is installed" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
				if systemctl is-enabled iptables | grep -q 'enabled' && systemctl is-active iptables | grep -q 'active'; then
					l_ipts="yyy"
					echo "- iptables-service is installed on the system, is enabled, and is active" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
				elif systemctl is-enabled iptables | grep -q 'enabled' && ! systemctl is-active iptables | grep -q 'active'; then
					l_ipts="yyn"
					echo "- iptables-service is installed on the system, is enabled, but is not active" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
				elif ! systemctl is-enabled iptables | grep -q 'enabled' && systemctl is-active iptables | grep -q 'active'; then
					l_ipts="yny"
					echo "- iptables-service is installed on the system, is disabled, but is active" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
				else
					l_ipts="ynn"
					echo "- iptables-service is installed on the system, is disabled, and is not active"  | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
				fi
			else
				echo "- iptables-service is not installed on the system"
				l_ipts="ynn"
			fi	
		fi
		echo "- End - Determine IPTables status" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
		
		# Determin which firewall is in use
		echo "- Start - Determine which firewall is in use" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
		# Check for no installed firewall
		if [[ "$l_fwds" = "nnn" && "$l_nfts" = "nnn" && "$l_ipts" = "nnn" ]]; then
			G_FWIN="NFi"
		# Check for multiple firewalls
		elif [[ "$l_nftr" = "y" && "$l_iptr" = "y" ]] || [[ "$l_fwds" =~ yy. && "$l_nfts" =~ yy. ]] || [[ "$l_fwds" =~ yy. && "$l_ipts" =~ yy. ]] || [[ "$l_nfts" =~ yy. && "$l_ipts" =~ yy. ]]; then
			G_FWIN="MFu"
		else
			# Check for which firewall
			# Check for FirewallD
			if [[ "$l_fwds" =~ yy. && "$l_nfts" =~ .nn && "$l_ipts" =~ .nn ]] && [[ "$l_nfts" =~ y.. || "$l_ipts" =~ y.. ]]; then
				G_FWIN="FWd"
			fi
			# Check for NFTables
			if [[ "$l_nfts" =~ yy. && "$l_fwds" =~ .nn && "$l_ipts" =~ .nn && -z "$l_iptr" ]]; then
				G_FWIN="NFt"
			fi
			# Check for IPTables
			if [[ -z "$G_FWIN" && "$l_ipts" =~ y.. && "$l_fwds" =~ .nn && "$l_nfts" =~ .nn && -z "$l_nftr" ]]; then
				G_FWIN="IPt"
			fi
		fi
		echo "- End - Determine which firewall is in use" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
		
		# Output results
		case "$G_FWIN" in
			FWd)
				echo "- Firewall determined to be FirewallD. Checks for NFTables and IPTables will be marked as Non Applicable" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
				;;
			NFt)
				echo "- Firewall determined to be NFTables. Checks for FirewallD and IPTables will be marked as Non Applicable" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
				;;
			IPt)
				echo "- Firewall determined to be IPTables. Checks for FirewallD and NFTables will be marked as Non Applicable" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
				;;
			NFi)
				echo "- No firewall is installed on the system. Firewall recommendations will be marked as MANUAL" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
				G_FWIN="UKn"
				;;
			MFu)
				echo "- Multiple firewalls in use on the system. Firewall recommendations will be marked as MANUAL" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
				G_FWIN="UKn"
				;;
			*)
				echo "- Unable to determine firewall. Firewall recommendations will be marked as MANUAL" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
				G_FWIN="UKn"
				;;
		esac
		export G_FWIN
		echo "- End - Check to determine Firewall in use on the system" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
	}
	
	firewalld_drops_unnecessary_services_and_ports_chk()
	{
		echo "- Start check - firewalld drops unnecessary services and ports" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
		l_output=""
			
		# Set package manager information
		if [ -z "$G_PQ" ] || [ -z "$G_PM" ] || [ -z "$G_PR" ]; then
			nix_package_manager_set
			if [ "$?" != "101" ]; then
				l_output="- Unable to determine system's package manager"
				test="manual"
			fi
		fi
		
		if $G_PQ firewalld >/dev/null; then
			( 
				echo -e "\nActive Zone output:\n--------------------"
				echo -e "\n $(firewall-cmd --list-all --zone="$(firewall-cmd --list-all | awk '/\(active\)/ { print $1 }')")"
				echo -e "--------------------\n"
			) | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
		fi
			
		# If package doesn't exist, we pass
		if [ -z "$l_output" ]; then
			(
				echo -e "- Manual review of active zone for unnecessary services and ports required"
				echo "- End check - firewalld drops unnecessary services and ports"
			) | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			return "${XCCDF_RESULT_PASS:-101}"
		else
			# print the reason why we are failing
			(
				echo -e "$l_output"
				echo "- End check - firewalld drops unnecessary services and ports"
			) | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
			return "${XCCDF_RESULT_FAIL:-102}"
		fi
	}
	
	firewalld_drops_unnecessary_services_and_ports_fix()
	{
		(
			echo -e "- Start remediation - firewalld drops unnecessary services and ports"
			echo -e "- Manual review of active zone for unnecessary services and ports required"
			echo -e "- End remediation - firewalld drops unnecessary services and ports"
		) | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
	}

	# Set firewall applicability
	[ -z "$G_FWIN" ] && fed_firewall_chk
	# Check to see if recommendation is applicable
	if [ "$G_FWIN" = "UKn" ]; then
		echo "- Firewall is unknown, Manual review is required" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
		test="manual"
	elif [ "$G_FWIN" != "FWd" ]; then
		echo "- FirewallD is not in use on the system, recommendation is not applicable" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
		test="NA"
	else
		firewalld_drops_unnecessary_services_and_ports_chk
		if [ "$?" = "101" ]; then
			[ -z "$test" ] && test="manual"
		else
			firewalld_drops_unnecessary_services_and_ports_fix
			firewalld_drops_unnecessary_services_and_ports_chk
			if [ "$?" = "101" ]; then
				[ "$test" != "failed" ] && test="manual"
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