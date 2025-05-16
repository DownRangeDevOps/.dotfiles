#!/usr/bin/env bash
# shellcheck shell=bash disable=SC1091

# Script to download uBlock Origin filter lists and store them locally
# Requirements:
# - curl
# - printf_callout, printf_error, printf_warning, printf_success, and indent_output functions must be available

# Exit on error
set -e

PATH="${PATH}:${HOME}/.dotfiles/bin"
source "${HOME}/.dotfiles/bash.d/lib.sh"

# Create directories if they don't exist
ALL_LISTS_PATH="${UBLOCK_DIR}/all-lists.txt"
UBLOCK_DIR="${HOME}/.dotfiles/app-settings/ublock-origin"
mkdir -p "${UBLOCK_DIR}"
rm -f "${ALL_LISTS_PATH}"

# Define the lists as an array of arrays: [name, url, documentation_url]
# Each list is defined as: name|url|documentation_url
declare -a LISTS=(
    # Adult site trackers
    "OISD NSFW Filter|https://nsfw.oisd.nl/|https://oisd.nl/"
    "OISD NSFW Small|https://nsfw-small.oisd.nl/|https://oisd.nl/"

    # Performance optimization lists
    "Web Annoyances Ultralist|https://raw.githubusercontent.com/yourduskquibbles/webannoyances/master/ultralist.txt|https://github.com/yourduskquibbles/webannoyances"
    "Web Annoyances Cookie Filters|https://raw.githubusercontent.com/yourduskquibbles/webannoyances/master/filters/cookie_filters.txt|https://github.com/yourduskquibbles/webannoyances"
    "Web Annoyances CSS Style Filters|https://raw.githubusercontent.com/yourduskquibbles/webannoyances/master/filters/css_style_filters.txt|https://github.com/yourduskquibbles/webannoyances"
    "Web Annoyances Modal Overlay Filters|https://raw.githubusercontent.com/yourduskquibbles/webannoyances/master/filters/modal_filters.txt|https://github.com/yourduskquibbles/webannoyances"
    "Web Annoyances Newsletter Filters|https://raw.githubusercontent.com/yourduskquibbles/webannoyances/master/filters/newsletter_filters.txt|https://github.com/yourduskquibbles/webannoyances"
    "1Hosts Lite|https://raw.githubusercontent.com/badmojr/1Hosts/master/Lite/adblock.txt|https://github.com/badmojr/1Hosts"
    "Energized Blu|https://block.energized.pro/blu/formats/filter|https://energized.pro/"

    # Comprehensive protection lists
    "OISD Big|https://big.oisd.nl/|https://oisd.nl/"
    "OISD Small|https://small.oisd.nl/|https://oisd.nl/"
)

# Array to store failed downloads
declare -a FAILED_DOWNLOADS=()

# Function to sanitize filenames
sanitize_filename() {
    echo "$1" | tr ' ' '_' | tr -d '()/' | tr -d "'" | tr -d '"' | tr '[:upper:]' '[:lower:]'
}

# Announce the start of the download process
printf "\n"
printf_callout "Downloading uBlock Origin filter lists"

# Process each list
for list in "${LISTS[@]}"; do
    # Parse the list information
    IFS='|' read -r name url doc_url <<<"$list"

    # Sanitize the name for use as filename
    filename=$(sanitize_filename "$name")
    output_file="${UBLOCK_DIR}/${filename}.txt"

    # Announce current download
    printf "Downloading %s (%s)" "$name" "$doc_url" | indent_output

    # Try downloading with retries
    success=false
    for attempt in {1..5}; do
        # Add a header comment with metadata
        {
            printf "%s" "! Title: $name"
            printf "%s" "! Source: $url"
            if [[ -n "$doc_url" && "$doc_url" != "null" ]]; then
                printf "%s" "! Documentation: $doc_url"
            fi
            printf "%s" "! Downloaded: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
            printf "%s" "!"
        } >"$output_file.tmp"

        # Download the list
        response=$(curl --silent --write-out '%{http_code}' --output "$output_file.tmp.content" --location \
            --connect-timeout 10 --max-time 30 \
            "$url")
        error_code=$?

        # Check for 404 error specifically
        if [[ "$response" == "404" ]]; then
            error_code=404
            printf_error "File does not exist at this URL, skipping retry attempts." | indent_output
            rm -f "$output_file.tmp" "$output_file.tmp.content"
            break
        fi

        # Process the download result
        if [[ "$error_code" -eq 0 && "$response" == "200" ]]; then
            # Success - append the content to the header file
            >>"$output_file.tmp" <("$output_file.tmp.content")
            mv "$output_file.tmp" "$output_file"
            rm -f "$output_file.tmp.content"

            # Add the list to the all-lists file
            >>"${ALL_LISTS_PATH}" <("$output_file")
            success=true
            break
        else
            # Failed attempt
            error_msg=$(curl --silent --location --show-error "$url" 2>&1 || true)

            # Only retry if we haven't reached the max attempts
            if [[ $attempt -lt 5 ]]; then
                printf_error "Error downloading %s, retrying... (Attempt %d/5)" "$name" "$attempt" | indent_output
                sleep 2 # Short delay before retrying
            fi

            # Clean up temp files
            rm -f "$output_file.tmp" "$output_file.tmp.content"
        fi
    done

    # Check if download was successful
    if [[ "$success" == "false" ]]; then
        FAILED_DOWNLOADS+=("$name|$error_code|$error_msg")
    fi
done

# Report results
if [[ ${#FAILED_DOWNLOADS[@]} -eq 0 ]]; then
    printf_success "All lists successfully updated. Done."
else
    printf "\n"
    printf_warning "${#FAILED_DOWNLOADS[@]} lists failed to download:" ""
    for failed in "${FAILED_DOWNLOADS[@]}"; do
        IFS='|' read -r name code msg <<<"$failed"
        printf_warning "$name failed to download: Error code $code" "$msg" | indent_output
    done
fi

exit ${#FAILED_DOWNLOADS[@]}
