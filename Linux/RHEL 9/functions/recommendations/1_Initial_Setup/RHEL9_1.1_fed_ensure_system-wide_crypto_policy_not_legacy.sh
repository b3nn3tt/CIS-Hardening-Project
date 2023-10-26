#!/usr/bin/env bash

########################################################################
#                                                                      #
# Author: b3nn3tt@hbcomputersecurity.co.uk                             #
# Version: 1.0                                                         #
# Git: https://github.com/b3nn3tt                                      #
#                                                                      #
# File Name:   nix_fed_ensure_system-wide_crypto_policy_not_legacy.sh  #
# Description: Applies recommendation as described                     #
#                                                                      #
########################################################################

LOG_BUFFER=""

append_log() {
    local message="$1"
    LOG_BUFFER="${LOG_BUFFER}${message}\n"
}

write_log() {
    echo -e "$LOG_BUFFER" | tee -a "$VERBOSE_LOG" 2>> "$ERROR_LOG"
    LOG_BUFFER=""
}

fed_ensure_system-wide_crypto_policy_not_legacy() {
    append_log "\n**************************************************"
    append_log "- $(date +%d-%b-%Y' '%T)"
    append_log "- Start Recommendation \"$RN - $RNA\""

    l_test=""

    fed_ensure_system-wide_crypto_policy_not_legacy_chk() {
        append_log "- Start check - Ensure system-wide crypto policy is not legacy"

        l_output="$(grep -Pi -- '^\h*LEGACY\h*(\h+#.*)?$' /etc/crypto-policies/config)"

        if [ -z "$l_output" ]; then
            append_log "- PASS: The system-wide crypto policy is NOT set to LEGACY"
            append_log "- End check - Ensure system-wide crypto policy is not legacy"
            return "${XCCDF_RESULT_PASS:-101}"
        else
            append_log "- FAIL: The system-wide crypto policy IS set to LEGACY"
            append_log "- End check - Ensure system-wide crypto policy is not legacy"
            return "${XCCDF_RESULT_FAIL:-102}"
        fi 
    }

    fed_ensure_system-wide_crypto_policy_not_legacy_fix() {
        append_log "- Start remediation - Ensure system-wide crypto policy is not legacy"
        append_log "- Setting system-wide crypto policy to DEFAULT"
        update-crypto-policies --set DEFAULT
        append_log "- Activating updated system-wide crypto policy"
        update-crypto-policies
        append_log "- End remediation - Ensure system-wide crypto policy is not legacy"
    }

    fed_ensure_system-wide_crypto_policy_not_legacy_chk
    if [ "$?" = "101" ]; then
        [ -z "$l_test" ] && l_test="passed"
    else
        if [ "$l_test" != "NA" ]; then
            fed_ensure_system-wide_crypto_policy_not_legacy_fix
            if [ "$l_test" != "manual" ]; then
                fed_ensure_system-wide_crypto_policy_not_legacy_chk
                if [ "$?" = "101" ] ; then
                    [ "$l_test" != "failed" ] && l_test="remediated"
                else
                    l_test="failed"
                fi
            fi
        fi
    fi

    case "$l_test" in
        passed)
            append_log "- Result - No remediation required"
            ;;
        remediated)
            append_log "- Result - successfully remediated"
            ;;
        manual)
            append_log "- Result - requires manual remediation"
            ;;
        NA)
            append_log "- Result - Recommendation is non applicable"
            ;;
        *)
            append_log "- Result - remediation failed"
            ;;
    esac

    append_log "- End Recommendation \"$RN - $RNA\""
    append_log "**************************************************\n"

    write_log

    case "$l_test" in
        passed|remediated|NA) return "${XCCDF_RESULT_PASS:-101}" ;;
        manual) return "${XCCDF_RESULT_FAIL:-106}" ;;
        *) return "${XCCDF_RESULT_FAIL:-102}" ;;
    esac
}

