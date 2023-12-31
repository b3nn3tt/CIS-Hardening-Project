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
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

# 1.1.2 - Securely Configure /tmp Directory
RN="1.1.2.1"
RNA="Ensure /tmp is a separate partition"
PROFILE="L1S L1W"
REC="ensure_tmp_separate_partition"
FSN="RHEL9_1.1.2.1_ensure_tmp_separate_partition.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.1.2.2"
RNA="Ensure nodev option set on /tmp partition"
PROFILE="L1S L1W"
REC="ensure_nodev_set_tmp_partition"
FSN="RHEL9_1.1.2.2_ensure_nodev_set_tmp_partition.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.1.2.3"
RNA="Ensure noexec option set on /tmp partition"
PROFILE="L1S L1W"
REC="ensure_noexec_set_tmp_partition"
FSN="RHEL9_1.1.2.3_ensure_noexec_set_tmp_partition.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.1.2.4"
RNA="Ensure nosuid option set on /tmp partition"
PROFILE="L1S L1W"
REC="ensure_nosuid_set_tmp_partition"
FSN="RHEL9_1.1.2.4_ensure_nosuid_set_tmp_partition.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

# 1.1.3 - Securely Configure /var Directory
RN="1.1.3.1"
RNA="Ensure separate partition exists for /var"
PROFILE="L2S L2W"
REC="ensure_var_separate_partition"
FSN="RHEL9_1.1.3.1_ensure_var_separate_partition.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.1.3.2"
RNA="Ensure nodev option set on /var partition"
PROFILE="L1S L1W"
REC="ensure_nodev_set_var_partition"
FSN="RHEL9_1.1.3.2_ensure_nodev_set_var_partition.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.1.3.3"
RNA="Ensure nosuid option set on /var partition"
PROFILE="L1S L1W"
REC="ensure_nosuid_set_var_partition"
FSN="RHEL9_1.1.3.3_ensure_nosuid_set_var_partition"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

# 1.1.4 - Securely Configure /var/tmp
RN="1.1.4.1"
RNA="Ensure separate partition exists for /var/tmp"
PROFILE="L2S L2W"
REC="ensure_var_tmp_separate_partition"
FSN="RHEL9_1.1.4.1_ensure_var_tmp_separate_partition.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.1.4.2"
RNA="Ensure noexec option set on /var/tmp partition"
PROFILE="L1S L1W"
REC="ensure_noexec_set_var_tmp_partition"
FSN="RHEL9_1.1.4.2_ensure_noexec_set_var_tmp_partition.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.1.4.3"
RNA="Ensure nosuid option set on /var/tmp partition"
PROFILE="L1S L1W"
REC="ensure_nosuid_set_var_tmp_partition"
FSN="RHEL9_1.1.4.3_ensure_nosuid_set_var_tmp_partition.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.1.4.4"
RNA="Ensure nodev option set on /var/tmp partition"
PROFILE="L1S L1W"
REC="ensure_nodev_set_var_tmp_partition"
FSN="RHEL9_1.1.4.4_ensure_nodev_set_var_tmp_partition.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

# 1.1.5 - Securely Configure /var/log Directory
RN="1.1.5.1"
RNA="Ensure separate partition exists for /var/log"
PROFILE="L2S L2W"
REC="ensure_var_log_separate_partition"
FSN="RHEL9_1.1.5.1_ensure_var_log_separate_partition.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.1.5.2"
RNA="Ensure nodev option set on /var/log partition"
PROFILE="L1S L1W"
REC="ensure_nodev_set_var_log_partition"
FSN="RHEL9_1.1.5.2_ensure_nodev_set_var_log_partition.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.1.5.3"
RNA="Ensure noexec option set on /var/log partition"
PROFILE="L1S L1W"
REC="ensure_noexec_set_var_log_partition"
FSN="RHEL9_1.1.5.3_ensure_noexec_set_var_log_partition.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.1.5.4"
RNA="Ensure nosuid option set on /var/log partition"
PROFILE="L1S L1W"
REC="ensure_nosuid_set_var_log_partition"
FSN="RHEL9_1.1.5.4_ensure_nosuid_set_var_log_partition.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

# 1.1.6 - Configure /var/log/audit
RN="1.1.6.1"
RNA="Ensure separate partition exists for /var/log/audit"
PROFILE="L2S L2W"
REC="ensure_var_log_audit_separate_partition"
FSN="RHEL9_1.1.6.1_ensure_var_log_audit_separate_partition.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.1.6.2"
RNA="Ensure noexec option set on /var/log/audit partition"
PROFILE="L1S L1W"
REC="ensure_noexec_set_var_log_audit_partition"
FSN="RHEL9_1.1.6.2_ensure_noexec_set_var_log_audit_partition.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.1.6.3"
RNA="Ensure nodev option set on /var/log/audit partition"
PROFILE="L1S L1W"
REC="ensure_nodev_set_var_log_audit_partition"
FSN="RHEL9_1.1.6.3_ensure_nodev_set_var_log_audit_partition.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.1.6.4"
RNA="Ensure nosuid option set on /var/log/audit partition"
PROFILE="L1S L1W"
REC="ensure_nosuid_set_var_log_audit_partition"
FSN="RHEL9_1.1.6.4_ensure_nosuid_set_var_log_audit_partition.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

# 1.1.7 - Securely Configure /home Directory
RN="1.1.7.1"
RNA="Ensure separate partition exists for /home"
PROFILE="L2S L2W"
REC="ensure_home_separate_partition"
FSN="RHEL9_1.1.7.1_ensure_home_separate_partition.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.1.7.2"
RNA="Ensure nodev option set on /home partition"
PROFILE="L1S L1W"
REC="ensure_nodev_set_home_partition"
FSN="RHEL9_1.1.7.2_ensure_nodev_set_home_partition.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.1.7.3"
RNA="Ensure nosuid option set on /home partition"
PROFILE="L1S L1W"
REC="ensure_nosuid_set_home_partition"
FSN="RHEL9_1.1.7.3_ensure_nosuid_set_home_partition.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

# 1.1.8 - Securely Configure /dev/shm Directory
RN="1.1.8.1"
RNA="Ensure /dev/shm is a separate partition"
PROFILE="L1S L1W"
REC="ensure_dev_shm_separate_partition"
FSN="RHEL9_1.1.8.1_ensure_dev_shm_separate_partition.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.1.8.2"
RNA="Ensure nodev option set on /dev/shm partition"
PROFILE="L1S L1W"
REC="ensure_nodev_set_dev_shm_partition"
FSN="RHEL9_1.1.8.2_ensure_nodev_set_dev_shm_partition.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.1.8.3"
RNA="Ensure noexec option set on /dev/shm partition"
PROFILE="L1S L1W"
REC="ensure_noexec_set_dev_shm_partition"
FSN="RHEL9_1.1.8.3_ensure_noexec_set_dev_shm_partition.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.1.8.4"
RNA="Ensure nosuid option set on /dev/shm partition"
PROFILE="L1S L1W"
REC="ensure_nosuid_set_dev_shm_partition"
FSN="RHEL9_1.1.8.4_ensure_nosuid_set_dev_shm_partition.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

# 1.1.9 - Disable USB Storage
RN="1.1.9"
RNA="Disable USB Storage"
PROFILE="L1S L2W"
REC="disable_usb_storage"
FSN="RHEL9_1.1.9_disable_usb_storage.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

########### 1.2.x CONFIGURE SOFTWARE UPDATES ###########

RN="1.2.1"
RNA="Ensure GPG keys are configured"
PROFILE="L1S L1W"
REC="ensure_gpg_keys_configured"
FSN="RHEL9_1.2.1_ensure_gpg_keys_configured.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.2.2"
RNA="Ensure gpgcheck is globally activated"
PROFILE="L1S L1W"
REC="fed_ensure_gpgcheck_globally_activated"
FSN="RHEL9_1.2.2_fed_ensure_gpgcheck_globally_activated.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.2.3"
RNA="Ensure package manager repositories are configured"
PROFILE="L1S L1W"
REC="ensure_package_manager_repositories_configured"
FSN="RHEL9_1.2.3_ensure_package_manager_repositories_configured.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.2.4"
RNA="Ensure repo_gpgcheck is globally activated"
PROFILE="L2S L2W"
REC="fed_ensure_repo_gpgcheck_globally_activated"
FSN="RHEL9_1.2.4_fed_ensure_repo_gpgcheck_globally_activated.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

########### 1.3.x FILESYSTEM INTEGRITY CHECKING ###########

RN="1.3.1"
RNA="Ensure AIDE is installed"
PROFILE="L1S L1W"
REC="ensure_aide_installed"
FSN="RHEL9_1.3.1_ensure_aide_installed.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.3.2"
RNA="Ensure filesystem integrity is regularly checked"
PROFILE="L1S L1W"
REC="ensure_filesystem_integrity_regularly_checked"
FSN="RHEL9_1.3.2_ensure_filesystem_integrity_regularly_checked.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.3.3"
RNA="Ensure cryptographic mechanisms are used to protect the integrity of audit tools"
PROFILE="L1S L1W"
REC="fed_ensure_cryptographic_mechanisms_used_protect_integrity_audit_tools"
FSN="RHEL9_1.3.3_fed_ensure_cryptographic_mechanisms_used_protect_integrity_audit_tools.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

########### 1.4.x SECURE BOOT SETTINGS ###########

RN="1.4.1"
RNA="Ensure bootloader password is set"
PROFILE="L1S L1W"
REC="fed_ensure_bootloader_password_set"
FSN="RHEL9_1.4.1_fed_ensure_bootloader_password_set.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.4.2"
RNA="Ensure permissions on bootloader config are configured"
PROFILE="L1S L1W"
REC="fed34_ensure_permissions_bootloader_config_configured"
FSN="RHEL9_1.4.2_fed34_ensure_permissions_bootloader_config_configured.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

########### 1.5.x ADDITIONAL PROCESS HARDENING ###########

RN="1.5.1"
RNA="Ensure core dump storage is disabled"
PROFILE="L1S L1W"
REC="ensure_core_dump_storage_disabled"
FSN="RHEL9_1.5.1_ensure_core_dump_storage_disabled.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.5.2"
RNA="Ensure core dump backtraces are disabled"
PROFILE="L1S L1W"
REC="ensure_core_dump_backtraces_disabled"
FSN="RHEL9_1.5.2_ensure_core_dump_backtraces_disabled.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.5.3"
RNA="Ensure address space layout randomization (ASLR) is enabled"
PROFILE="L1S L1W"
REC="ensure_address_space_layout_randomization_enabled"
FSN="RHEL9_1.5.3_ensure_address_space_layout_randomization_enabled.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

########### 1.6.x MANDATORY ACCESS CONTROL ###########

# 1.6.1 - Configure SELinux
RN="1.6.1.1"
RNA="Ensure SELinux is installed"
PROFILE="L1S L1W"
REC="fed_ensure_selinux_installed"
FSN="RHEL9_1.6.1.1_fed_ensure_selinux_installed.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.6.1.2"
RNA="Ensure SELinux is not disabled in bootloader configuration"
PROFILE="L1S L1W"
REC="fed28_ensure_selinux_not_disabled_bootloader_configuration"
FSN="RHEL9_1.6.1.2_fed28_ensure_selinux_not_disabled_bootloader_configuration.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.6.1.3"
RNA="Ensure SELinux policy is configured"
PROFILE="L1S L1W"
REC="fed_ensure_selinux_policy_configured"
FSN="RHEL9_1.6.1.3_fed_ensure_selinux_policy_configured.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.6.1.4"
RNA="Ensure the SELinux mode is not disabled"
PROFILE="L1S L1W"
REC="fed_ensure_selinux_state_enforcing_or_permissive"
FSN="RHEL9_1.6.1.4_fed_ensure_selinux_state_enforcing_or_permissive.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.6.1.5"
RNA="Ensure the SELinux mode is enforcing"
PROFILE="L2S L2W"
REC="fed_ensure_selinux_state_enforcing"
FSN="RHEL9_1.6.1.5_fed_ensure_selinux_state_enforcing"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.6.1.6"
RNA="Ensure no unconfined services exist"
PROFILE="L1S L1W"
REC="fed_ensure_no_unconfined_services_exist"
FSN="RHEL9_1.6.1.6_fed_ensure_no_unconfined_services_exist.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.6.1.7"
RNA="Ensure SETroubleshoot is not installed"
PROFILE="L1S"
REC="fed_ensure_setroubleshoot_not_installed"
FSN="RHEL9_1.6.1.7_fed_ensure_setroubleshoot_not_installed.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.6.1.8"
RNA="Ensure the MCS Translation Service (mcstrans) is not installed"
PROFILE="L1S L1W"
REC="fed_ensure_mcstrans_not_installed"
FSN="RHEL9_1.6.1.8_fed_ensure_mcstrans_not_installed.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

########### 1.7.x COMMAND LINE WARNING BANNERS ###########

RN="1.7.1"
RNA="Ensure message of the day is configured properly"
PROFILE="L1S L1W"
REC="ensure_motd_configured"
FSN="RHEL9_1.7.1_ensure_motd_configured.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.7.2"
RNA="Ensure local login warning banner is configured properly"
PROFILE="L1S L1W"
REC="ensure_local_login_warning_banner_configured"
FSN="RHEL9_1.7.2_ensure_local_login_warning_banner_configured.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.7.3"
RNA="Ensure remote login warning banner is configured properly"
PROFILE="L1S L1W"
REC="ensure_remote_login_warning_banner_configured"
FSN="RHEL9_1.7.3_ensure_remote_login_warning_banner_configured.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.7.4"
RNA="Ensure permissions on /etc/motd are configured"
PROFILE="L1S L1W"
REC="ensure_permissions_motd_configured"
FSN="RHEL9_1.7.4_ensure_permissions_motd_configured.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.7.5"
RNA="Ensure permissions on /etc/issue are configured"
PROFILE="L1S L1W"
REC="ensure_permissions_issue_configured"
FSN="RHEL9_1.7.5_ensure_permissions_issue_configured.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.7.6"
RNA="Ensure permissions on /etc/issue.net are configured"
PROFILE="L1S L1W"
REC="ensure_permissions_issue_net_configured"
FSN="RHEL9_1.7.6_ensure_permissions_issue_net_configured.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

########### 1.8.s GNOME DISPLAY MANAGER ###########

RN="1.8.1"
RNA="Ensure GNOME Display Manager is removed"
PROFILE="L2S"
REC="ensure_gdm_removed"
FSN="RHEL9_1.8.1_ensure_gdm_removed.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.8.2"
RNA="Ensure GDM login banner is configured"
PROFILE="L1S L1W"
REC="ensure_gdm_login_banner_configured"
FSN="RHEL9_1.8.2_ensure_gdm_login_banner_configured.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.8.3"
RNA="Ensure GDM disable-user-list option is enabled"
PROFILE="L1S L1W"
REC="ensure_gdm_disable-user-list_option_enabled"
FSN="RHEL9_1.8.3_ensure_gdm_disable-user-list_option_enabled.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.8.4"
RNA="Ensure GDM screen locks when the user is idle"
PROFILE="L1S L1W"
REC="ensure_gdm_screen_locks_when_user_idle"
FSN="RHEL9_1.8.4_ensure_gdm_screen_locks_when_user_idle.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.8.5"
RNA="Ensure GDM screen locks cannot be overridden"
PROFILE="L1S L1W"
REC="ensure_gdm_screen_locks_cannot_be_overridden"
FSN="RHEL9_1.8.5_ensure_gdm_screen_locks_cannot_be_overridden.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.8.6"
RNA="Ensure GDM automatic mounting of removable media is disabled"
PROFILE="L1S L2W"
REC="ensure_gdm_auto_mount_removable_media_disabled"
FSN="RHEL9_1.8.6_ensure_gdm_auto_mount_removable_media_disabled.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.8.7"
RNA="Ensure GDM disabling automatic mounting of removable media is not overridden"
PROFILE="L1S L2W"
REC="ensure_gdm_disable_auto_mount_cannot_be_overridden"
FSN="RHEL9_1.8.7_ensure_gdm_disable_auto_mount_cannot_be_overridden.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.8.8"
RNA="Ensure GDM autorun-never is enabled"
PROFILE="L1S L1W"
REC="ensure_gdm_autorun-never_enabled"
FSN="RHEL9_1.8.8_ensure_gdm_autorun-never_enabled.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.8.9"
RNA="Ensure GDM autorun-never is not overridden"
PROFILE="L1S L1W"
REC="ensure_gdm_autorun-never_cannot_be_overridden"
FSN="RHEL9_1.8.9_ensure_gdm_autorun-never_cannot_be_overridden.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.8.10"
RNA="Ensure XDCMP is not enabled"
PROFILE="L1S L1W"
REC="fed_ensure_xdmcp_not_enabled"
FSN="RHEL9_1.8.10_fed_ensure_xdmcp_not_enabled.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="1.9"
RNA="Ensure updates, patches, and additional security software are installed"
PROFILE="L1S L1W"
REC="ensure_updates_patches_security_software_installed"
FSN="RHEL9_1.9_ensure_updates_patches_security_software_installed.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

#######################
##### 2. SERVICES #####
#######################

##### 2.1.x TIME SYNCHRONISATION #####

RN="2.1.1"
RNA="Ensure time synchronization is in use"
PROFILE="L1S L1W"
REC="fed_ensure_time_synchronization_in_use"
FSN="RHEL9_2.1.1_fed_ensure_time_synchronization_in_use.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="2.1.2"
RNA="Ensure chrony is configured"
PROFILE="L1S L1W"
REC="fed_chrony_configured"
FSN="RHEL9_2.1.2_fed_chrony_configured.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

##### 2.2.x SPECIAL PURPOSE SERVICES #####

RN="2.2.1"
RNA="Ensure xorg-x11-server-common is not installed"
PROFILE="L2S"
REC="ensure_x11_server_components_not_installed"
FSN="RHEL9_2.2.1_ensure_x11_server_components_not_installed.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="2.2.2"
RNA="Ensure Avahi Server is not installed"
PROFILE="L1S L2W"
REC="ensure_avahi_server_not_installed"
FSN="RHEL9_2.2.2_ensure_avahi_server_not_installed.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="2.2.3"
RNA="Ensure CUPS is not installed"
PROFILE="L1S"
REC="ensure_cups_not_installed"
FSN="RHEL9_2.2.3_ensure_cups_not_installed.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="2.2.4"
RNA="Ensure DHCP Server is not installed"
PROFILE="L1S L1W"
REC="ensure_dhcp_server_not_installed"
FSN="RHEL9_2.2.4_ensure_dhcp_server_not_installed.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="2.2.5"
RNA="Ensure DNS Server is not installed"
PROFILE="L1S L1W"
REC="ensure_dns_server_not_installed"
FSN="RHEL9_2.2.5_ensure_dns_server_not_installed.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="2.2.6"
RNA="Ensure VSFTP Server is not installed"
PROFILE="L1S L1W"
REC="ensure_vsftp_server_not_installed"
FSN="RHEL9_2.2.6_ensure_vsftp_server_not_installed.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="2.2.7"
RNA="Ensure TFTP Server is not installed"
PROFILE="L1S L1W"
REC="ensure_tftp_client_not_installed"
FSN="RHEL9_2.2.7_ensure_tftp_client_not_installed.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="2.2.8"
RNA="Ensure a web server is not installed"
PROFILE="L1S L1W"
REC="ensure_web_server_not_installed"
FSN="RHEL9_2.2.8_ensure_web_server_not_installed.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="2.2.9"
RNA="Ensure IMAP and POP3 server is not installed"
PROFILE="L1S L1W"
REC="ensure_imap_and_pop3_server_not_installed"
FSN="RHEL9_2.2.9_ensure_imap_and_pop3_server_not_installed.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="2.2.10"
RNA="Ensure Samba is not installed"
PROFILE="L1S L1W"
REC="ensure_samba_not_installed"
FSN="RHEL9_2.2.10_ensure_samba_not_installed.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="2.2.11"
RNA="Ensure HTTP Proxy Server is not installed"
PROFILE="L1S L1W"
REC="ensure_http_proxy_server_not_installed"
FSN="RHEL9_2.2.11_ensure_http_proxy_server_not_installed.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="2.2.12"
RNA="Ensure net-snmp is not installed"
PROFILE="L1S L1W"
REC="ensure_snmp_server_not_installed"
FSN="RHEL9_2.2.12_ensure_snmp_server_not_installed.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="2.2.13"
RNA="Ensure telnet-server is not installed"
PROFILE="L1S L1W"
REC="fed_ensure_telnet_server_not_installed"
FSN="RHEL9_2.2.13_fed_ensure_telnet_server_not_installed.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="2.2.14"
RNA="Ensure dnsmasq is not installed"
PROFILE="L1S L1W"
REC="fed_ensure_dnsmasq_not_installed"
FSN="RHEL9_2.2.14_fed_ensure_dnsmasq_not_installed.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="2.2.15"
RNA="Ensure mail transfer agent is configured for local-only mode"
PROFILE="L1S L1W"
REC="ensure_mail_transfer_agent_configured_local_only"
FSN="RHEL9_2.2.15_ensure_mail_transfer_agent_configured_local_only.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="2.2.16"
RNA="Ensure nfs-utils is not installed or the nfs-server service is masked"
PROFILE="L1S L1W"
REC="fed_ensure_nfs_server_not_installed_or_masked"
FSN="RHEL9_2.2.16_fed_ensure_nfs_server_not_installed_or_masked.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="2.2.17"
RNA="Ensure rpcbind is not installed or the rpcbind services are masked"
PROFILE="L1S L1W"
REC="fed_ensure_rpcbind_not_installed_or_masked"
FSN="RHEL9_2.2.17_fed_ensure_rpcbind_not_installed_or_masked.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="2.2.18"
RNA="Ensure rsync-daemon is not installed or the rsyncd service is masked"
PROFILE="L1S L1W"
REC="ensure_rsync_service_not_enabled"
FSN="RHEL9_2.2.18_ensure_rsync_service_not_enabled.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

##### 2.3.x SERVICE CLIENTS #####

RN="2.3.1"
RNA="Ensure telnet client is not installed"
PROFILE="L1S L1W"
REC="ensure_telnet_client_not_installed"
FSN="RHEL9_2.3.1_ensure_telnet_client_not_installed.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="2.3.2"
RNA="Ensure LDAP client is not installed"
PROFILE="L1S L1W"
REC="ensure_ldap_client_not_installed"
FSN="RHEL9_2.3.2_ensure_ldap_client_not_installed.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="2.3.3"
RNA="Ensure TFTP client is not installed"
PROFILE="L1S L1W"
REC="ensure_tftp_client_not_installed"
FSN="RHEL9_2.2.7_ensure_tftp_client_not_installed.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="2.3.4"
RNA="Ensure FTP client is not installed"
PROFILE="L1S L1W"
REC="ensure_ftp_client_not_installed"
FSN="RHEL9_2.3.4_ensure_ftp_client_not_installed.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

##### 2.4 NON-ESSENTIAL SERVICES #####

RN="2.4"
RNA="Ensure nonessential services listening on the system are removed or masked"
PROFILE="L1S L1W"
REC="ensure_nonessential_services_removed_or_masked"
FSN="RHEL9_2.4_ensure_nonessential_services_removed_or_masked.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

####################################
##### 3. NETWORK CONFIGURATION #####
####################################

##### 3.1.x UNUSED NETWORK PROTOCOLS AND DEVICES #####

RN="3.1.1"
RNA="Ensure IPv6 status is identified"
PROFILE="L1S L1W"
REC="fed_ensure_ipv6_status_identified"
FSN="RHEL9_3.1.1_fed_ensure_ipv6_status_identified.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="3.1.2"
RNA="Ensure wireless interfaces are disabled"
PROFILE="L1S"
REC="ensure_wireless_interfaces_disabled"
FSN="RHEL9_3.1.2_ensure_wireless_interfaces_disabled.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="3.1.3"
RNA="Ensure TIPC is disabled"
PROFILE="L2S L2W"
REC="ensure_tipc_disabled"
FSN="RHEL9_3.1.3_ensure_tipc_disabled.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

##### 3.2.x IP FORWARDING #####

RN="3.2.1"
RNA="Ensure IP forwarding is disabled"
PROFILE="L1S L1W"
REC="ensure_ip_forwarding_disabled"
FSN="RHEL9_3.2.1_ensure_ip_forwarding_disabled.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="3.2.2"
RNA="Ensure packet redirect sending is disabled"
PROFILE="L1S L1W"
REC="ensure_packet_redirect_sending_disabled"
FSN="RHEL9_3.2.2_ensure_packet_redirect_sending_disabled.sh"
TOTAL_RECOMMENDATIONS=$((total_recommendations+1))
run_recommendation

##### 3.3.x NETWORK PARAMETERS: HOST AND ROUTER #####

RN="3.3.1"
RNA="Ensure source routed packets are not accepted"
PROFILE="L1S L1W"
REC="ensure_source_routed_packets_not_accepted"
FSN="RHEL9_3.3.1_ensure_source_routed_packets_not_accepted.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="3.3.2"
RNA="Ensure ICMP redirects are not accepted"
PROFILE="L1S L1W"
REC="ensure_icmp_redirects_not_accepted"
FSN="RHEL9_3.3.2_ensure_icmp_redirects_not_accepted.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="3.3.3"
RNA="Ensure secure ICMP redirects are not accepted"
PROFILE="L1S L1W"
REC="ensure_secure_icmp_redirects_not_accepted"
FSN="RHEL9_3.3.3_ensure_secure_icmp_redirects_not_accepted.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="3.3.4"
RNA="Ensure suspicious packets are logged"
PROFILE="L1S L1W"
REC="ensure_suspicious_packets_logged"
FSN="RHEL9_3.3.4_ensure_suspicious_packets_logged.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="3.3.5"
RNA="Ensure broadcast ICMP requests are ignored"
PROFILE="L1S L1W"
REC="ensure_broadcast_icmp_requests_ignored"
FSN="RHEL9_3.3.5_ensure_broadcast_icmp_requests_ignored.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="3.3.6"
RNA="Ensure bogus ICMP responses are ignored"
PROFILE="L1S L1W"
REC="ensure_bogus_icmp_responses_ignored"
FSN="RHEL9_3.3.6_ensure_bogus_icmp_responses_ignored.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="3.3.7"
RNA="Ensure Reverse Path Filtering is enabled"
PROFILE="L1S L1W"
REC="ensure_reverse_path_filtering_enabled"
FSN="RHEL9_3.3.7_ensure_reverse_path_filtering_enabled.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="3.3.8"
RNA="Ensure TCP SYN Cookies is enabled"
PROFILE="L1S L1W"
REC="ensure_tcp_syn_cookies_enabled"
FSN="RHEL9_3.3.8_ensure_tcp_syn_cookies_enabled.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="3.3.9"
RNA="Ensure IPv6 router advertisements are not accepted"
PROFILE="L1S L1W"
REC="ensure_ipv6_router_advertisements_not_accepted"
FSN="RHEL9_3.3.9_ensure_ipv6_router_advertisements_not_accepted.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

##### 3.4.x CONFIGURE HOST BASED FIREWALL #####

# 3.4.1.x CONFIGURE A FIREWALL UTILITY

RN="3.4.1.1"
RNA="Ensure nftables is installed"
PROFILE="L1S L1W"
REC="fed_ensure_nftables_installed"
FSN="RHEL9_3.4.1.1_fed_ensure_nftables_installed.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="3.4.1.2"
RNA="Ensure a single firewall configuration utility is in use"
PROFILE="L1S L1W"
REC="fed_ensure_single_firewall_configuration_utility"
FSN="RHEL9_3.4.1.2_fed_ensure_single_firewall_configuration_utility.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

# 3.4.2.x - CONFIGURE FIREWALL RULES

RN="3.4.2.1"
RNA="Ensure firewalld default zone is set"
PROFILE="L1S L1W"
REC="fed_ensure_firewalld_default_zone_set"
FSN="RHEL9_3.4.2.1_fed_ensure_firewalld_default_zone_set.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="3.4.2.2"
RNA="Ensure at least one nftables table exists"
PROFILE="L1S L1W"
REC="fed_ensure_nftables_table_exists"
FSN="RHEL9_3.4.2.2_fed_ensure_nftables_table_exists.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="3.4.2.3"
RNA="Ensure nftables base chains exist"
PROFILE="L1S L1W"
REC="fed_ensure_nftables_base_chains_exist"
FSN="RHEL9_3.4.2.3_fed_ensure_nftables_base_chains_exist.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="3.4.2.4"
RNA="Ensure host based firewall loopback traffic is configured"
PROFILE="L1S L1W"
REC="fed_ensure_nftables_loopback_traffic_is_configured"
FSN="RHEL9_3.4.2.4_fed_ensure_nftables_loopback_traffic_is_configured.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="3.4.2.5"
RNA="Ensure firewalld drops unnecessary services and ports"
PROFILE="L1S L1W"
REC="fed_ensure_firewalld_drops_unnecessary_services_and_ports"
FSN="RHEL9_3.4.2.5_fed_ensure_firewalld_drops_unnecessary_services_and_ports.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="3.4.2.6"
RNA="Ensure nftables established connections are configured"
PROFILE="L1S L1W"
REC="fed_ensure_nftables_outbound_established_connections_configured"
FSN="RHEL9_3.4.2.6_fed_ensure_nftables_outbound_established_connections_configured.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation

RN="3.4.2.7"
RNA="Ensure nftables default deny firewall policy"
PROFILE="L1S L1W"
REC="fed_ensure_nftables_default_deny_firewall_policy"
FSN="RHEL9_3.4.2.7_fed_ensure_nftables_default_deny_firewall_policy.sh"
TOTAL_RECOMMENDATIONS=$((TOTAL_RECOMMENDATIONS+1))
run_recommendation
