#!/usr/bin/env bash

########################################################################
#                                                                      #
# Author: b3nn3tt@hbcomputersecurity.co.uk                             #
# Version: 1.0                                                         #
# Git: https://github.com/b3nn3tt                                      #
#                                                                      #
# File Name:   RHEL9_1.1.3.1_ensure_var_separate_partition.sh          #
# Description: Ensures separate partition exists for /var              #
#                                                                      #
########################################################################

ensure_var_separate_partition()
{

echo -e "\n**************************************************\n- $(date +%d-%b-%Y' '%T)\n- Start Recommendation \"$RN - $RNA\"" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
   test=""

   ensure_var_separate_partition_chk()
   {
      echo -e "- Start check - Ensure separate partition exists for /var" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
      XCCDF_VALUE_REGEX="/var"
      l_partition_test=""

      if findmnt --kernel "$XCCDF_VALUE_REGEX"; then
            echo -e "- $XCCDF_VALUE_REGEX is a separate partition\n$(findmnt --kernel $XCCDF_VALUE_REGEX)" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
            l_partition_test="passed"
      else
            echo -e "- $XCCDF_VALUE_REGEX is NOT a separate partition" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
      fi

      if [ "$l_partition_test" = "passed" ]; then
         echo -e "- PASS:\n- $XCCDF_VALUE_REGEX is properly configured"  | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
         echo -e "- End check - Ensure separate partition exists for /var" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
         return "${XCCDF_RESULT_PASS:-101}"
      else
         echo -e "- FAIL:\n- $XCCDF_VALUE_REGEX is NOT properly configured" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
         echo -e "- End check - Ensure separate partition exists for /var" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
         return "${XCCDF_RESULT_FAIL:-102}"
      fi
   }


   ensure_var_separate_partition_fix()
   {
      echo -e "- Start remediation - Ensure separate partition exists for /var" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"

      echo -e "- For new installations, during installation create a custom partition setup and specify a separate partition for /var.\n- For systems that were previously installed, create a new partition and configure /etc/fstab as appropriate." | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"

      test=manual

      echo -e "- End remediation - Ensure separate partition exists for /var" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
   }

   ensure_var_separate_partition_chk
   if [ "$?" = "101" ]; then
      [ -z "$test" ] && test="passed"
   else
      ensure_var_separate_partition_fix
      if [ "$test" != "manual" ]; then
         ensure_var_separate_partition_chk
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
