#!/usr/bin/env bash

/usr/local/bin/fd --type d --unrestricted --full-path --glob "**/.terraform" "${HOME}" | \
    while read -r path; do
        printf "%s\n" "Excluding: ${path}"
        /usr/bin/tmutil addexclusion "${path}"
    done
