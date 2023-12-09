#!/usr/bin/env bash
# shellcheck disable=SC2030,SC2031  # Each test is expected to modify exported vars

setup() {
    load ../../../external/test_helper/bats-assert/load
    load ../../../external/test_helper/bats-files/load
    load ../../../external/test_helper/bats-support/load
    load ./test_helpers.sh

    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    PATH="$DIR/../.git-template/hooks:$PATH"

    export SUBJECT="this-is-a-subject"
    export FORMATTED_SUBJECT="This is a subject"
    export ISSUE_TYPE="fix"
    export USER_INITIALS="rf"
    export TICKET_ID="JIRA2-1234"
    export COMMIT_SOURCE="template"

    # shellcheck disable=SC2034  # Used by prepare-commit-msg
    export PROJECT_TRACKER_URL="https://example.com/"

    export COMMIT_MSG_FILE="$(mktemp)"
}

# <subject>
@test "subject should match branch name without hyphens in title case" {
    export CUR_BRANCH="${SUBJECT}"
    EXPECTED_SUBJECT="${FORMATTED_SUBJECT}"
    run prepare-commit-msg "${COMMIT_MSG_FILE}" "${COMMIT_SOURCE}"
    assert_success
    show_commit_message_input_output_expected
    [[ "$(head -1 "${COMMIT_MSG_FILE}")" == "${EXPECTED_SUBJECT}" ]]
}

# <ticket-id>--<subject>
@test "subject should match branch name without hyphens in title case with ticket id" {
    export CUR_BRANCH="${TICKET_ID}--${SUBJECT}"
    EXPECTED_SUBJECT="${FORMATTED_SUBJECT} [[${TICKET_ID}]]"
    run prepare-commit-msg "${COMMIT_MSG_FILE}" "${COMMIT_SOURCE}"
    assert_success
    show_commit_message_input_output_expected
    [[ "$(head -1 "${COMMIT_MSG_FILE}")" == "${EXPECTED_SUBJECT}" ]]
}

# # <user-initials>/<subject>
@test "subject should match branch name without hyphens in title case without user initials" {
    export CUR_BRANCH="${USER_INITIALS}/${SUBJECT}"
    EXPECTED_SUBJECT="${FORMATTED_SUBJECT}"
    run prepare-commit-msg "${COMMIT_MSG_FILE}" "${COMMIT_SOURCE}"
    assert_success
    show_commit_message_input_output_expected
    [[ "$(head -1 "${COMMIT_MSG_FILE}")" == "${FORMATTED_SUBJECT}" ]]
}

# # <user-initials>/<ticket-id>--<subject>
@test "subject should match branch name without hyphens in title case with ticket id without user initials" {
    export CUR_BRANCH="${USER_INITIALS}/${TICKET_ID}--${SUBJECT}"
    EXPECTED_SUBJECT="${FORMATTED_SUBJECT} [[${TICKET_ID}]]"
    run prepare-commit-msg "${COMMIT_MSG_FILE}" "${COMMIT_SOURCE}"
    assert_success
    show_commit_message_input_output_expected
    [[ "$(head -1 "${COMMIT_MSG_FILE}")" == "${EXPECTED_SUBJECT}" ]]
}

# # <issue-type>/<user-initials>/<subject>
@test "subject should match branch name without hyphens in title case with type" {
    export CUR_BRANCH="${ISSUE_TYPE}/${USER_INITIALS}/${SUBJECT}"
    EXPECTED_SUBJECT="${ISSUE_TYPE}: ${FORMATTED_SUBJECT}"
    run prepare-commit-msg "${COMMIT_MSG_FILE}" "${COMMIT_SOURCE}"
    assert_success
    show_commit_message_input_output_expected
    [[ "$(head -1 "${COMMIT_MSG_FILE}")" == "${EXPECTED_SUBJECT}" ]]
}

# <issue-type>-<issue-scope>/<user-initials>/<subject>
@test "subject should match branch name without hyphens in title case with type and scope" {
    export CUR_BRANCH="${ISSUE_TYPE}-scope/${USER_INITIALS}/${SUBJECT}"
    EXPECTED_SUBJECT="${ISSUE_TYPE}(scope): ${FORMATTED_SUBJECT}"
    run prepare-commit-msg "${COMMIT_MSG_FILE}" "${COMMIT_SOURCE}"
    assert_success
    show_commit_message_input_output_expected
    [[ "$(head -1 "${COMMIT_MSG_FILE}")" == "${EXPECTED_SUBJECT}" ]]
}

# <issue-type>/<user-initials>/<ticket-id>--<subject>
@test "subject should match branch name without hyphens in title case with type and ticket id" {
    export CUR_BRANCH="${ISSUE_TYPE}/${USER_INITIALS}/${TICKET_ID}--${SUBJECT}"
    EXPECTED_SUBJECT="${ISSUE_TYPE}: ${FORMATTED_SUBJECT} [[${TICKET_ID}]]"
    run prepare-commit-msg "${COMMIT_MSG_FILE}" "${COMMIT_SOURCE}"
    assert_success
    show_commit_message_input_output_expected
    [[ "$(head -1 "${COMMIT_MSG_FILE}")" == "${EXPECTED_SUBJECT}" ]]
}

# <issue-type>-<issue-scope>/<user-initials>/<ticket-id>--<subject>
@test "subject should match branch name without hyphens in title case with type, scope, and ticket id" {
    export CUR_BRANCH="${ISSUE_TYPE}-scope/${USER_INITIALS}/${TICKET_ID}--${SUBJECT}"
    EXPECTED_SUBJECT="${ISSUE_TYPE}(scope): ${FORMATTED_SUBJECT} [[${TICKET_ID}]]"
    run prepare-commit-msg "${COMMIT_MSG_FILE}" "${COMMIT_SOURCE}"
    assert_success
    # assert_output "FDSFDS"
    show_commit_message_input_output_expected
    [[ "$(head -1 "${COMMIT_MSG_FILE}")" == "${EXPECTED_SUBJECT}" ]]
}

teardown() {
    rm -f "${COMMIT_MSG_FILE}"
    unset SUBJECT
    unset FORMATTED_SUBJECT
    unset ISSUE_TYPE
    unset USER_INITIALS
    unset TICKET_ID
    unset COMMIT_SOURCE
    unset PROJECT_TRACKER_URL
    unset COMMIT_MSG_FILE
    unset CUR_BRANCH
}
