#!/usr/bin/env bash

###########################################################
#                                                         #
# Author: b3nn3tt@hbcomputersecurity.co.uk                #
# Version: 1.0                                            #
# Git: https://github.com/b3nn3tt                         #
#                                                         #
# File Name:   RHEL_9_CIS_Hardening.sh                    #
#                                                         #
###########################################################

# Ensure script is executed in bash
if [ ! "$BASH_VERSION" ] ; then
    exec /bin/bash "$0" "$@"
fi

# Ensure script is running with root privileges (REQUIRED)
if [ "$EUID" -ne 0 ]; then
    echo -e "\e[1;31m[*] ERROR [*]\e[0m The CIS Benchmark Deployment Tool must be run with \e[1;31mroot privileges\e[0m. This process will now terminate..."
    exit 1
fi

####################################
##### GLOBAL VARIABLES SECTION #####
####################################

# Current Date Time Group at time of execution
DTG=$(date +%m-%d-%Y_%H%M)

# Directories
BASE_DIR="$(dirname "$(readlink -f "$0")")"
FUNC_DIR=$BASE_DIR/functions
REC_DIR=$FUNC_DIR/recommendations
GEN_DIR=$FUNC_DIR/general
LOG_DIR=$BASE_DIR/logs
RESOURCES_DIR=$BASE_DIR/resources
CURRENT_LOG_DIR=$LOG_DIR/$DTG

# Log Files
VERBOSE_LOG=$CURRENT_LOG_DIR/verbose.log
SUMMARY_LOG=$CURRENT_LOG_DIR/summary.log
ERROR_LOG=$CURRENT_LOG_DIR/error.log
FAILED_LOG=$CURRENT_LOG_DIR/failed.log
MANUAL_LOG=$CURRENT_LOG_DIR/manual.log

# CIS PDF Reference
PDF_LOCATION=$(find $RESOURCES_DIR -type f -name "*.pdf")

# Counters
PASSED_RECOMMENDATIONS="0"
FAILED_RECOMMENDATIONS="0"
REMEDIATED_RECOMMENDATIONS="0"
NOT_APPLICABLE_RECOMMENDATIONS="0"
EXCLUDED_RECOMMENDATIONS="0"
MANUAL_RECOMMENDATIONS="0"
SKIPPED_RECOMMENDATIONS="0"
TOTAL_RECOMMENDATIONS="0"


#####################################
##### IMPORT REQUIRED FUNCTIONS #####
#####################################

# General Functions
for FUNC in "$GEN_DIR"/*.sh; do
	[ -e "$FUNC" ] || break
	. "$FUNC"
done

# CIS Recommendation Functions
for FUNC in "$REC_DIR"/**/*.sh; do
	[ -e "$FUNC" ] || break
	. "$FUNC"
done

############################
##### EXECUTION BEGINS #####
############################

# Clear Screen
clear

# Display Banner
display_banner

# Display Warning Message
warning
sleep 3

# Create Log Files
create_log_files

# Select which CIS Control Level to implement
select_control_level

#########################################################
################## CIS RECOMMENDATIONS ##################
#########################################################

############################
##### 1. INITIAL SETUP #####
############################

##### 1.1.x FILESYSTEM CONFIGURATION #####

# 1.1 - Filesystem Configuration #
RN="1.1"
RNA="Ensure system-wide crypto policy is not legacy"
PROFILE="L1S L1W"
REC="fed_ensure_system-wide_crypto_policy_not_legacy"
FSN="RHEL9_1.1_fed_ensure_system-wide_crypto_policy_not_legacy.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

# 1.1.1 - Disable unused filesystems
RN="1.1.1.1"
RNA="Ensure mounting of squashfs filesystems is disabled"
PROFILE="L2S L2W"
REC="ensure_squashfs_filesystem_disabled"
FSN="RHEL9_1.1.1.1_ensure_squashfs_filesystem_disabled.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.1.1.2"
RNA="Ensure mounting of udf filesystems is disabled"
PROFILE="L2S L2W"
REC="ensure_udf_filesystem_disabled"
FSN="RHEL9_1.1.1.2_ensure_udf_filesystem_disabled.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

# 1.1.2 - Securely Configure /tmp Directory
RN="1.1.2.1"
RNA="Ensure /tmp is a separate partition"
PROFILE="L1S L1W"
REC="ensure_tmp_separate_partition"
FSN="RHEL9_1.1.2.1_ensure_tmp_separate_partition.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.1.2.2"
RNA="Ensure nodev option set on /tmp partition"
PROFILE="L1S L1W"
REC="ensure_nodev_set_tmp_partition"
FSN="RHEL9_1.1.2.2_ensure_nodev_set_tmp_partition.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.1.2.3"
RNA="Ensure noexec option set on /tmp partition"
PROFILE="L1S L1W"
REC="ensure_noexec_set_tmp_partition"
FSN="RHEL9_1.1.2.3_ensure_noexec_set_tmp_partition.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.1.2.4"
RNA="Ensure nosuid option set on /tmp partition"
PROFILE="L1S L1W"
REC="ensure_nosuid_set_tmp_partition"
FSN="RHEL9_1.1.2.4_ensure_nosuid_set_tmp_partition.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

# 1.1.3 - Securely Configure /var Directory
RN="1.1.3.1"
RNA="Ensure separate partition exists for /var"
PROFILE="L2S L2W"
REC="ensure_var_separate_partition"
FSN="RHEL9_1.1.3.1_ensure_var_separate_partition.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.1.3.2"
RNA="Ensure nodev option set on /var partition"
PROFILE="L1S L1W"
REC="ensure_nodev_set_var_partition"
FSN="RHEL9_1.1.3.2_ensure_nodev_set_var_partition.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.1.3.3"
RNA="Ensure nosuid option set on /var partition"
PROFILE="L1S L1W"
REC="ensure_nosuid_set_var_partition"
FSN="RHEL9_1.1.3.3_ensure_nosuid_set_var_partition"
total_recommendations=$((total_recommendations+1))
run_recommendation

# 1.1.4 - Securely Configure /var/tmp
RN="1.1.4.1"
RNA="Ensure separate partition exists for /var/tmp"
PROFILE="L2S L2W"
REC="ensure_var_tmp_separate_partition"
FSN="RHEL9_1.1.4.1_ensure_var_tmp_separate_partition.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.1.4.2"
RNA="Ensure noexec option set on /var/tmp partition"
PROFILE="L1S L1W"
REC="ensure_noexec_set_var_tmp_partition"
FSN="RHEL9_1.1.4.2_ensure_noexec_set_var_tmp_partition.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.1.4.3"
RNA="Ensure nosuid option set on /var/tmp partition"
PROFILE="L1S L1W"
REC="ensure_nosuid_set_var_tmp_partition"
FSN="RHEL9_1.1.4.3_ensure_nosuid_set_var_tmp_partition.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.1.4.4"
RNA="Ensure nodev option set on /var/tmp partition"
PROFILE="L1S L1W"
REC="ensure_nodev_set_var_tmp_partition"
FSN="RHEL9_1.1.4.4_ensure_nodev_set_var_tmp_partition.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

# 1.1.5 - Securely Configure /var/log Directory
RN="1.1.5.1"
RNA="Ensure separate partition exists for /var/log"
PROFILE="L2S L2W"
REC="ensure_var_log_separate_partition"
FSN="RHEL9_1.1.5.1_ensure_var_log_separate_partition.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.1.5.2"
RNA="Ensure nodev option set on /var/log partition"
PROFILE="L1S L1W"
REC="ensure_nodev_set_var_log_partition"
FSN="RHEL9_1.1.5.2_ensure_nodev_set_var_log_partition.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.1.5.3"
RNA="Ensure noexec option set on /var/log partition"
PROFILE="L1S L1W"
REC="ensure_noexec_set_var_log_partition"
FSN="RHEL9_1.1.5.3_ensure_noexec_set_var_log_partition.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.1.5.4"
RNA="Ensure nosuid option set on /var/log partition"
PROFILE="L1S L1W"
REC="ensure_nosuid_set_var_log_partition"
FSN="RHEL9_1.1.5.4_ensure_nosuid_set_var_log_partition.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

# 1.1.6 - Configure /var/log/audit
RN="1.1.6.1"
RNA="Ensure separate partition exists for /var/log/audit"
PROFILE="L2S L2W"
REC="ensure_var_log_audit_separate_partition"
FSN="RHEL9_1.1.6.1_ensure_var_log_audit_separate_partition.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.1.6.2"
RNA="Ensure noexec option set on /var/log/audit partition"
PROFILE="L1S L1W"
REC="ensure_noexec_set_var_log_audit_partition"
FSN="RHEL9_1.1.6.2_ensure_noexec_set_var_log_audit_partition.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.1.6.3"
RNA="Ensure nodev option set on /var/log/audit partition"
PROFILE="L1S L1W"
REC="ensure_nodev_set_var_log_audit_partition"
FSN="RHEL9_1.1.6.3_ensure_nodev_set_var_log_audit_partition.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.1.6.4"
RNA="Ensure nosuid option set on /var/log/audit partition"
PROFILE="L1S L1W"
REC="ensure_nosuid_set_var_log_audit_partition"
FSN="RHEL9_1.1.6.4_ensure_nosuid_set_var_log_audit_partition.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

# 1.1.7 - Securely Configure /home Directory 
RN="1.1.7.1"
RNA="Ensure separate partition exists for /home"
PROFILE="L2S L2W"
REC="ensure_home_separate_partition"
FSN="RHEL9_1.1.7.1_ensure_home_separate_partition.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.1.7.2"
RNA="Ensure nodev option set on /home partition"
PROFILE="L1S L1W"
REC="ensure_nodev_set_home_partition"
FSN="RHEL9_1.1.7.2_ensure_nodev_set_home_partition.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.1.7.3"
RNA="Ensure nosuid option set on /home partition"
PROFILE="L1S L1W"
REC="ensure_nosuid_set_home_partition"
FSN="RHEL9_1.1.7.3_ensure_nosuid_set_home_partition.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

# 1.1.8 - Securely Configure /dev/shm Directory
RN="1.1.8.1"
RNA="Ensure /dev/shm is a separate partition"
PROFILE="L1S L1W"
REC="ensure_dev_shm_separate_partition"
FSN="RHEL9_1.1.8.1_ensure_dev_shm_separate_partition.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.1.8.2"
RNA="Ensure nodev option set on /dev/shm partition"
PROFILE="L1S L1W"
REC="ensure_nodev_set_dev_shm_partition"
FSN="RHEL9_1.1.8.2_ensure_nodev_set_dev_shm_partition.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.1.8.3"
RNA="Ensure noexec option set on /dev/shm partition"
PROFILE="L1S L1W"
REC="ensure_noexec_set_dev_shm_partition"
FSN="RHEL9_1.1.8.3_ensure_noexec_set_dev_shm_partition.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.1.8.4"
RNA="Ensure nosuid option set on /dev/shm partition"
PROFILE="L1S L1W"
REC="ensure_nosuid_set_dev_shm_partition"
FSN="RHEL9_1.1.8.4_ensure_nosuid_set_dev_shm_partition.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

# 1.1.9 - Disable USB Storage
RN="1.1.9"
RNA="Disable USB Storage"
PROFILE="L1S L2W"
REC="disable_usb_storage"
FSN="RHEL9_1.1.9_disable_usb_storage.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

########### 1.2.x CONFIGURE SOFTWARE UPDATES ###########

RN="1.2.1"
RNA="Ensure GPG keys are configured"
PROFILE="L1S L1W"
REC="ensure_gpg_keys_configured"
FSN="RHEL9_1.2.1_ensure_gpg_keys_configured.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.2.2"
RNA="Ensure gpgcheck is globally activated"
PROFILE="L1S L1W"
REC="fed_ensure_gpgcheck_globally_activated"
FSN="RHEL9_1.2.2_fed_ensure_gpgcheck_globally_activated.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.2.3"
RNA="Ensure package manager repositories are configured"
PROFILE="L1S L1W"
REC="ensure_package_manager_repositories_configured"
FSN="RHEL9_1.2.3_ensure_package_manager_repositories_configured.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.2.4"
RNA="Ensure repo_gpgcheck is globally activated"
PROFILE="L2S L2W"
REC="fed_ensure_repo_gpgcheck_globally_activated"
FSN="RHEL9_1.2.4_fed_ensure_repo_gpgcheck_globally_activated.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

########### 1.3.x FILESYSTEM INTEGRITY CHECKING ###########

RN="1.3.1"
RNA="Ensure AIDE is installed"
PROFILE="L1S L1W"
REC="ensure_aide_installed"
FSN="RHEL9_1.3.1_ensure_aide_installed.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.3.2"
RNA="Ensure filesystem integrity is regularly checked"
PROFILE="L1S L1W"
REC="ensure_filesystem_integrity_regularly_checked"
FSN="RHEL9_1.3.2_ensure_filesystem_integrity_regularly_checked.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.3.3"
RNA="Ensure cryptographic mechanisms are used to protect the integrity of audit tools"
PROFILE="L1S L1W"
REC="fed_ensure_cryptographic_mechanisms_used_protect_integrity_audit_tools"
FSN="RHEL9_1.3.3_fed_ensure_cryptographic_mechanisms_used_protect_integrity_audit_tools.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

########### 1.4.x SECURE BOOT SETTINGS ###########

RN="1.4.1"
RNA="Ensure bootloader password is set"
PROFILE="L1S L1W"
REC="fed_ensure_bootloader_password_set"
FSN="RHEL9_1.4.1_fed_ensure_bootloader_password_set.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.4.2"
RNA="Ensure permissions on bootloader config are configured"
PROFILE="L1S L1W"
REC="fed34_ensure_permissions_bootloader_config_configured"
FSN="RHEL9_1.4.2_fed34_ensure_permissions_bootloader_config_configured.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

########### 1.5.x ADDITIONAL PROCESS HARDENING ###########

RN="1.5.1"
RNA="Ensure core dump storage is disabled"
PROFILE="L1S L1W"
REC="ensure_core_dump_storage_disabled"
FSN="RHEL9_1.5.1_ensure_core_dump_storage_disabled.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.5.2"
RNA="Ensure core dump backtraces are disabled"
PROFILE="L1S L1W"
REC="ensure_core_dump_backtraces_disabled"
FSN="RHEL9_1.5.2_ensure_core_dump_backtraces_disabled.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.5.3"
RNA="Ensure address space layout randomization (ASLR) is enabled"
PROFILE="L1S L1W"
REC="ensure_address_space_layout_randomization_enabled"
FSN="RHEL9_1.5.3_ensure_address_space_layout_randomization_enabled.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

########### 1.6.x MANDATORY ACCESS CONTROL ###########

# 1.6.1 - Configure SELinux
RN="1.6.1.1"
RNA="Ensure SELinux is installed"
PROFILE="L1S L1W"
REC="fed_ensure_selinux_installed"
FSN="RHEL9_1.6.1.1_fed_ensure_selinux_installed.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.6.1.2"
RNA="Ensure SELinux is not disabled in bootloader configuration"
PROFILE="L1S L1W"
REC="fed28_ensure_selinux_not_disabled_bootloader_configuration"
FSN="RHEL9_1.6.1.2_fed28_ensure_selinux_not_disabled_bootloader_configuration.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.6.1.3"
RNA="Ensure SELinux policy is configured"
PROFILE="L1S L1W"
REC="fed_ensure_selinux_policy_configured"
FSN="RHEL9_1.6.1.3_fed_ensure_selinux_policy_configured.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.6.1.4"
RNA="Ensure the SELinux mode is not disabled"
PROFILE="L1S L1W"
REC="fed_ensure_selinux_state_enforcing_or_permissive"
FSN="RHEL9_1.6.1.4_fed_ensure_selinux_state_enforcing_or_permissive.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.6.1.5"
RNA="Ensure the SELinux mode is enforcing"
PROFILE="L2S L2W"
REC="fed_ensure_selinux_state_enforcing"
FSN="RHEL9_1.6.1.5_fed_ensure_selinux_state_enforcing"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.6.1.6"
RNA="Ensure no unconfined services exist"
PROFILE="L1S L1W"
REC="fed_ensure_no_unconfined_services_exist"
FSN="RHEL9_1.6.1.6_fed_ensure_no_unconfined_services_exist.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.6.1.7"
RNA="Ensure SETroubleshoot is not installed"
PROFILE="L1S"
REC="fed_ensure_setroubleshoot_not_installed"
FSN="RHEL9_1.6.1.7_fed_ensure_setroubleshoot_not_installed.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.6.1.8"
RNA="Ensure the MCS Translation Service (mcstrans) is not installed"
PROFILE="L1S L1W"
REC="fed_ensure_mcstrans_not_installed"
FSN="RHEL9_1.6.1.8_fed_ensure_mcstrans_not_installed.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

########### 1.7.x COMMAND LINE WARNING BANNERS ###########

RN="1.7.1"
RNA="Ensure message of the day is configured properly"
PROFILE="L1S L1W"
REC="ensure_motd_configured"
FSN="RHEL9_1.7.1_ensure_motd_configured.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.7.2"
RNA="Ensure local login warning banner is configured properly"
PROFILE="L1S L1W"
REC="ensure_local_login_warning_banner_configured"
FSN="RHEL9_1.7.2_ensure_local_login_warning_banner_configured.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.7.3"
RNA="Ensure remote login warning banner is configured properly"
PROFILE="L1S L1W"
REC="ensure_remote_login_warning_banner_configured"
FSN="RHEL9_1.7.3_ensure_remote_login_warning_banner_configured.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.7.4"
RNA="Ensure permissions on /etc/motd are configured"
PROFILE="L1S L1W"
REC="ensure_permissions_motd_configured"
FSN="RHEL9_1.7.4_ensure_permissions_motd_configured.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.7.5"
RNA="Ensure permissions on /etc/issue are configured"
PROFILE="L1S L1W"
REC="ensure_permissions_issue_configured"
FSN="RHEL9_1.7.5_ensure_permissions_issue_configured.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.7.6"
RNA="Ensure permissions on /etc/issue.net are configured"
PROFILE="L1S L1W"
REC="ensure_permissions_issue_net_configured"
FSN="RHEL9_1.7.6_ensure_permissions_issue_net_configured.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

########### 1.8.s GNOME DISPLAY MANAGER ###########

RN="1.8.1"
RNA="Ensure GNOME Display Manager is removed"
PROFILE="L2S"
REC="ensure_gdm_removed"
FSN="RHEL9_1.8.1_ensure_gdm_removed.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.8.2"
RNA="Ensure GDM login banner is configured"
PROFILE="L1S L1W"
REC="ensure_gdm_login_banner_configured"
FSN="RHEL9_1.8.2_ensure_gdm_login_banner_configured.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.8.3"
RNA="Ensure GDM disable-user-list option is enabled"
PROFILE="L1S L1W"
REC="ensure_gdm_disable-user-list_option_enabled"
FSN="RHEL9_1.8.3_ensure_gdm_disable-user-list_option_enabled.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.8.4"
RNA="Ensure GDM screen locks when the user is idle"
PROFILE="L1S L1W"
REC="ensure_gdm_screen_locks_when_user_idle"
FSN="RHEL9_1.8.4_ensure_gdm_screen_locks_when_user_idle.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.8.5"
RNA="Ensure GDM screen locks cannot be overridden"
PROFILE="L1S L1W"
REC="ensure_gdm_screen_locks_cannot_be_overridden"
FSN="RHEL9_1.8.5_ensure_gdm_screen_locks_cannot_be_overridden.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.8.6"
RNA="Ensure GDM automatic mounting of removable media is disabled"
PROFILE="L1S L2W"
REC="ensure_gdm_auto_mount_removable_media_disabled"
FSN="RHEL9_1.8.6_ensure_gdm_auto_mount_removable_media_disabled.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.8.7"
RNA="Ensure GDM disabling automatic mounting of removable media is not overridden"
PROFILE="L1S L2W"
REC="ensure_gdm_disable_auto_mount_cannot_be_overridden"
FSN="RHEL9_1.8.7_ensure_gdm_disable_auto_mount_cannot_be_overridden.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.8.8"
RNA="Ensure GDM autorun-never is enabled"
PROFILE="L1S L1W"
REC="ensure_gdm_autorun-never_enabled"
FSN="RHEL9_1.8.8_ensure_gdm_autorun-never_enabled.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.8.9"
RNA="Ensure GDM autorun-never is not overridden"
PROFILE="L1S L1W"
REC="ensure_gdm_autorun-never_cannot_be_overridden"
FSN="RHEL9_1.8.9_ensure_gdm_autorun-never_cannot_be_overridden.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.8.10"
RNA="Ensure XDCMP is not enabled"
PROFILE="L1S L1W"
REC="fed_ensure_xdmcp_not_enabled"
FSN="RHEL9_1.8.10_fed_ensure_xdmcp_not_enabled.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation

RN="1.9"
RNA="Ensure updates, patches, and additional security software are installed"
PROFILE="L1S L1W"
REC="ensure_updates_patches_security_software_installed"
FSN="RHEL9_1.9_ensure_updates_patches_security_software_installed.sh"
total_recommendations=$((total_recommendations+1))
run_recommendation
