#!/usr/bin/env bash

function show_commit_message_input_output_expected() {
    printf "%s\n" "Branch name set to: ${CUR_BRANCH}"
    printf "%s\n" "Created subject: $(head -1 "${COMMIT_MSG_FILE}")"
    printf "%s\n" "Expected subject: ${EXPECTED_SUBJECT}"
}
