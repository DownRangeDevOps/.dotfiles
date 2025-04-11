# shellcheck shell=bash disable=SC2296

if [[ -n "${DEBUG:-}" ]]; then
    log debug ""
    log debug "==> [${BASH_SOURCE[0]:-${(%):-%x}}]"
fi

# ------------------------------------------------
#  helpers
# ------------------------------------------------
if [[ -n "${DEBUG:-}" ]]; then
    log debug "[$(basename "${BASH_SOURCE[0]:-${(%):-%x}}")]: Loading helpers..."
fi

function dvrm() {
    volumes=$(docker volume ls |
        awk '{if (NR!=1) {print $2}}' |
        grep "${1:-.*}" --no-color)

    if [[ ${volumes} ]]; then
        printf_callout "Volumes to remove:"
        printf "%s\n" "${volumes}"

        # Prompt user
        prompt_to_continue "Delete volumes?" || return 3

        for volume in $volumes; do
            docker volume rm "${volume}"
        done
    else
        printf_callout "No matching volumes found."
    fi
}

function docker_ps() {
    docker ps "${@}" | less -RSFX
}

# Search tags on docker hub
function search_docker_tags() {
    name=${1:-}

    # Initial URL
    url="https://registry.hub.docker.com/v2/repositories/library/${name}/tags/?page_size=100"

    (
        # Keep looping until the variable URL is empty
        while [ -n "${url}" ]; do
            # Every iteration of the loop prints out a single dot to show progress as
            # it got through all the pages (this is inline dot)
            printf >&2 "%s" "."

            # Curl the URL and pipe the output to Python. Python will parse the JSON
            # and print the very first line as the next URL (it will leave it blank
            # if there are no more pages)
            #
            # then continue to loop over the results extracting only the name; all
            # will be stored in a variable called content
            content=$(
                curl -s "${url}" |
                    python -c "$(sed -E "s/^ *//" <(printf "%s" '
                    import sys, json; data = json.load(sys.stdin)
                    print(data.get("next", "") or "")
                    print("\n".join([x["name"] for x in data["results"]]))
            '))"
            )

            # Let's get the first line of content which contains the next URL for the
            # loop to continue
            url=$(printf "%s\n" "$content" | head -n 1)

            # Print the content without the first line (yes +2 is counter intuitive)
            printf "%s\n" "$content" | tail -n +2
        done

        # Finally break the line of dots
        echo >&2
    ) | cut -d '-' -f 1 | sort --version-sort | uniq
}

function docker_select_image() {

    # Get list of running containers
    containers=$(docker ps --format="{{.ID}}")

    if [[ -z $containers ]]; then
        printf_error "No running containers found"
    else
        docker ps
        printf "\n" # flush stdout buffer
        printf "%s\n" "Select a container to exec into (sh):"

        # Display in select menu
        select container in $containers; do

            # Extract fields
            name=$(printf "%s\n" "$container" | cut -f1)
            id=$(printf "%s\n" "$container" | cut -f2)

            # Exec bash in selected container
            docker exec -it "$id" sh
            break
        done
    fi
}

function docker_exec() {
    if [[ ${1:-} =~ 'help' ]]; then
        printf "%s\n" \
            "Docker helper to connect to a running container" \
            "" \
            "    Usage: de <container> [<command>]"
        return 3
    elif [[ $# -eq 0 ]]; then
        printf "%s\n" "Select a container"
        docker_select_image
    else
        docker exec -ti "$@"
    fi
}
