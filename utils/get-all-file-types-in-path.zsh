#!/usr/bin/env zsh

# Exit on error, unset variables, and pipeline failures
set -euo pipefail

# Globals
SEARCH_ROOT="${1:-"$(basename "${PWD}")"}"
JOBS="${2:-4}"
REQUIRED_COMMANDS=("fd" "parallel" "rg" "file" "sort" "uniq" "wc")
TEMP_DIR=$(mktemp -d) || { printf "Failed to create temporary directory\n"; exit 1; }
TOTAL=0

# Files for tracking progress
FILES_LIST="$TEMP_DIR/files.txt"
EXTENSIONS_ALL="$TEMP_DIR/extensions_all.txt"
EXTENSIONS_UNIQUE="$TEMP_DIR/extensions_unique.txt"
FILETYPES_RAW="$TEMP_DIR/filetypes_raw.txt"
PROGRESS_COUNTER="$TEMP_DIR/progress_counter"
FINAL_OUTPUT="/tmp/filetypes.txt"

# Ensure the required commands are available
check_command() {
    command -v "$1" >/dev/null 2>&1 || { printf "Error: %s command not found\n" "$1"; exit 1; }
}

for cmd in "${REQUIRED_COMMANDS[@]}"; do
    check_command "$cmd"
done

# Confirm that the user wants to proceed
printf "Warning: Searching from %s using "${JOBS}" jobs. This may take a while.\n" "${SEARCH_ROOT}"
read -q "REPLY?Do you want to continue? (y/n) "
printf "\n"
if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
    printf "Exiting...\n"
    exit 0
fi

# Handle cleanup on exit
cleanup() {
    local exit_code=$?
    printf "\nCleaning up temporary files...\n"

    if [[ -d "$TEMP_DIR" ]]; then
        rm -rf "$TEMP_DIR"
    fi

    if [[ $exit_code -ne 0 ]]; then
        printf "Script terminated with error (code: %d)\n" "$exit_code"
    elif [[ $1 == "SIGINT" || $1 == "SIGTERM" ]]; then
        printf "Script terminated by user\n"
        exit 130
    elif [[ $1 != "EXIT" ]]; then
        printf "Script terminated by signal %s\n" "$1"
        exit 128
    fi

    exit $exit_code
}

# Register cleanup for various signals and normal exit
trap 'cleanup EXIT' EXIT
trap 'cleanup SIGINT' INT
trap 'cleanup SIGTERM' TERM
trap 'cleanup SIGHUP' HUP

find_all_files() {
    printf "🔍 Step "${1}"/"${2}": Finding all files in %s (this may take a while)...\n" "${SEARCH_ROOT}"

    # Define fd arguments
    FD_ARGS=(
        --unrestricted
        --follow
        --type file
    )

    # Exclude common directories and files
    FD_ARGS+=(
        --exclude '.git'
        --exclude '.svn'
        --exclude '.hg'
        --exclude 'node_modules'
        --exclude '__pycache__'
        --exclude 'venv'
        --exclude '.venv'
        --exclude '.virtualenv'
        --exclude 'dist'
        --exclude 'build'
        --exclude 'target'
        --exclude '.gradle'
        --exclude 'vendor'
        --exclude 'bower_components'
        --exclude '.npm'
        --exclude '.idea'
        --exclude '.vscode'
        --exclude '.vs'
        --exclude '.cache'
        --exclude '.sass-cache'
        --exclude '_site'
        --exclude 'docs/_build'
        --exclude '.docusaurus'
        --exclude 'tmp'
        --exclude '.tmp'
        --exclude 'out'
        --exclude '.terraform'
        --exclude '.DS_Store'
        --exclude '.pytest_cache'
        --exclude '.coverage'
        --exclude '.yarn'
        --exclude '*.egg-info'
        --exclude '*.o'
        --exclude '*.pyc'
        --exclude '*.class'
    )

    if ! fd "${FD_ARGS[@]}" . "${SEARCH_ROOT}" -0 > "$FILES_LIST" 2>/dev/null; then
        printf "Error: Failed to search files in %s\n" "${SEARCH_ROOT}"
        exit 1
    fi

    # Check if any files were found
    if [[ ! -s "$FILES_LIST" ]]; then
        printf "Warning: No files found in %s\n" "${SEARCH_ROOT}"
        exit 0
    fi

    file_count=${#${(0)"$(<$FILES_LIST)"}[@]}
    printf "✓ Found %s files\n" "$file_count"
}

extract_unique_file_extensions() {
    printf "🔍 Step "${1}"/"${2}": Extracting unique file extensions (this may take a while)...\n"

    # Create an empty array for extensions
    extensions=()

    # Read the null-delimited file list and process each file
    while IFS= read -rd '' file; do
        # Get just the filename (basename)
        filename=${file:t}

        # Check if file has more than one dot AND doesn't just start with a dot
        if [[ "$filename" == *.* && ! "$filename" =~ ^[.]([^.]*)$ ]]; then
            # Extract the extension (everything after the last dot)
            extension=${filename:e}

            # Add to array if not empty
            if [[ -n "$extension" ]]; then
                extensions+=("$extension")
            fi
        fi
    done < "$FILES_LIST"

    # Make the extension list unique
    typeset -U extensions
}

write_extensions_to_file() {
    printf "🔍 Step "${1}"/"${2}": Determining file types (this may take a while)...\n"
    if [[ ${#extensions[@]} -gt 0 ]]; then
        printf "%s\n" "${extensions[@]}" > "$EXTENSIONS_UNIQUE"

        local ext_count
        ext_count=${#extensions[@]}
        printf "✓ Extracted %s unique extensions\n" "$ext_count"
    else
        printf "Warning: No file extensions found\n"
        touch "$EXTENSIONS_UNIQUE"  # Create empty file
        exit 0
    fi

    # Set the total number of extensions for progress tracking
    TOTAL=$ext_count
}

determin_file_types() {
    printf "🔍 Step "${1}"/"${2}": Determining file types (this may take a while)...\n"

    # Create progress counter file
    > "${PROGRESS_COUNTER}"

    # Process extensions in parallel with error handling
    if ! cat "${EXTENSIONS_UNIQUE}" | parallel -j"${JOBS}" --eta --halt soon,fail=1% \
    'ext={};
    type=$(file --extension --brief "*.$ext" 2>/dev/null | sed "s/\/.*$//" | sed "s/???//g");
    if [ -n "$type" ]; then
        printf ".%s = \"%s\"\n" "$ext" "$type" >> '"${FILETYPES_RAW}"';
    fi;
    # Update progress counter
    echo >> '"${PROGRESS_COUNTER}"';
    current=$(wc -l < '"${PROGRESS_COUNTER}"');
    if (( current % 10 == 0 )); then
        percent=$((current * 100 / '"${TOTAL}"'));
        printf "⏳ Progress: %d/%d (%d%%)\r" "$current" "'"${TOTAL}"'" "$percent" > /dev/tty;
    fi'; then
        printf "\nError: Some file type detection operations failed\n"
        # Continue with the results we have instead of exiting
    fi

    printf "\n✓ Processed all %s extensions\n" "${TOTAL}"
}

display_results() {
    printf "🔍 Step "${1}"/"${2}": Finalizing results...\n"
    if ! sort "${FILETYPES_RAW}" 2>/dev/null | uniq > "${FINAL_OUTPUT}"; then
        printf "Error: Failed to sort and deduplicate results\n"
        exit 1
    fi

    local result_count
    result_count=$(wc -l < "${FINAL_OUTPUT}" | tr -d ' ')
    printf "✅ Complete! Results saved to %s (%s entries)\n" "${FINAL_OUTPUT}" "${result_count}"
}

TOTAL_STEPS=5

main() {
    find_all_files 1 "${TOTAL_STEPS}"
    extract_unique_file_extensions 2 "${TOTAL_STEPS}"
    write_extensions_to_file 3 "${TOTAL_STEPS}"
    determin_file_types 4 "${TOTAL_STEPS}"
    display_results 5 "${TOTAL_STEPS}"
}

# Run the program
main

# Normal exit (cleanup will be called by EXIT trap)
exit 0
