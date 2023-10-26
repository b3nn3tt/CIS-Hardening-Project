#!/usr/bin/env bash

########################################################################
#                                                                      #
# Author: b3nn3tt@hbcomputersecurity.co.uk                             #
# Version: 1.0                                                         #
# Git: https://github.com/b3nn3tt                                      #
#                                                                      #
# File Name:   RHEL9_1.1.8.1_ensure_dev_shm_separate_partition.sh      #
# Description: Ensures /dev/shm is configured                          #
#                                                                      #
########################################################################

ensure_dev_shm_separate_partition()
{

echo -e "\n**************************************************\n- $(date +%d-%b-%Y' '%T)\n- Start Recommendation \"$RN - $RNA\"" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
   test=""

   ensure_dev_shm_separate_partition_chk()
   {
      echo -e "- Start check - Ensure /dev/shm is configured" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
      XCCDF_VALUE_REGEX="/dev/shm"
      l_partition_test=""

      if [ "$test" != "remediated" ]; then
         if findmnt --kernel "$XCCDF_VALUE_REGEX"; then
            echo -e "- $XCCDF_VALUE_REGEX is a separate partition" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
            if grep -Pq "^\h*[^#]+\h+$XCCDF_VALUE_REGEX\h+" /etc/fstab || systemctl is-enabled tmp.mount | grep -q 'enabled'; then
               echo -e "- $XCCDF_VALUE_REGEX will be mounted at boot time" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
               l_partition_test="passed"
            else
               echo -e "- $XCCDF_VALUE_REGEX will NOT be mounted at boot time" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
            fi
         else
            echo -e "- $XCCDF_VALUE_REGEX is NOT a separate partition" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
         fi
      else
         if grep -Pq "^\h*[^#]+\h+$XCCDF_VALUE_REGEX\h+" /etc/fstab || systemctl is-enabled tmp.mount | grep -q 'enabled'; then
            echo -e "- $XCCDF_VALUE_REGEX will be mounted at boot time" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
            l_partition_test="passed"
         else
            echo -e "- $XCCDF_VALUE_REGEX will NOT be mounted at boot time" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
         fi
      fi

      if [ "$l_partition_test" = "passed" ]; then
         echo -e "- PASS:\n- $XCCDF_VALUE_REGEX is properly configured"  | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
         echo -e "- End check - Ensure /dev/shm is configured" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
         return "${XCCDF_RESULT_PASS:-101}"
      else
         echo -e "- FAIL:\n- $XCCDF_VALUE_REGEX is NOT properly configured" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
         echo -e "- End check - Ensure /dev/shm is configured" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
         return "${XCCDF_RESULT_FAIL:-102}"
      fi
   }


   ensure_dev_shm_separate_partition_fix()
   {
      echo -e "- Start remediation - Ensure /dev/shm is configured" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"

      if ! grep -Pq "^\h*[^#]+\h+$XCCDF_VALUE_REGEX\h+" /etc/fstab; then
         echo -e "- Updating $XCCDF_VALUE_REGEX in /etc/fstab" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
         echo "# Added by CIS Linux Build Kit" >> /etc/fstab
         echo "tmpfs   /dev/shm    tmpfs   defaults,noexec,nosuid,nodev,seclabel 0   0" >> /etc/fstab
      fi

      if grep -Pq "^\h*[^#]+\h+$XCCDF_VALUE_REGEX\h+" /etc/fstab; then
         test=remediated
      fi

      echo -e "- End remediation - Ensure /dev/shm is configured" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
   }

   ensure_dev_shm_separate_partition_chk
   if [ "$?" = "101" ]; then
      [ -z "$test" ] && test="passed"
   else
      ensure_dev_shm_separate_partition_fix
      ensure_dev_shm_separate_partition_chk
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
