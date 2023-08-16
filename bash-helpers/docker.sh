# docker.sh
logger "" "[${BASH_SOURCE[0]}]"

# ------------------------------------------------
#  aliases
# ------------------------------------------------
logger "[$(basename "${BASH_SOURCE[0]}")]: Loading aliases..."

alias d="docker"
alias dV="docker version"
alias da="docker attach"
alias db="docker build"
alias dcm="docker commit"
alias dcp="docker cp"
alias dcr="docker create"
alias dd="docker diff"
alias ddep="docker deploy"
alias de="docker_exec"
alias dev="docker events"
alias dex="docker export"
alias dh="docker history"
alias di="docker image"
alias dim="docker import"
alias din="docker info"
alias dins="docker inspect"
alias dk="docker kill"
alias dl="docker logs"
alias dld="docker load"
alias dlin="docker login"
alias dlout="docker logout"
alias dn="docker network"
alias dp="docker pause"
alias dpl="docker pull"
alias dps="docker_ps"
alias dpt="docker port"
alias dpu="docker push"
alias dr="docker run --rm"
alias drm="docker rm"
alias drmi="docker rmi"
alias drn="docker rename"
alias drst="docker restart"
alias ds="docker save"
alias dsr="docker search"
alias dst="docker start"
alias dstp="docker stop"
alias dsts="docker stats"
alias dt="docker top"
alias dtg="docker tag"
alias dunp="docker unpause"
alias dup="docker update"
alias dv="docker volume"
alias dw="docker wait"

# docker kill
alias dka='docker kill $(docker ps -q)'

# docker volume
alias dvls="docker volume ls"

# docker system
alias dsdf="docker system df"
alias dse="docker system envents"
alias dsi="docker system info"
alias dsp="docker system prune"

# compose
alias dc="docker compose"

# ------------------------------------------------
#  helpers
# ------------------------------------------------
logger "[$(basename "${BASH_SOURCE[0]}")]: Loading helpers..."

function dvrm() {
    volumes=$(docker volume ls \
        | awk '{if (NR!=1) {print $2}}' \
        | grep "${1:-.*}" --no-color)

    if [[ ${volumes} ]]; then
        printf_callout "Volumes to remove:"
        printf "%s\n" "${volumes}"

        if [[ $(prompt_to_continue "Delete volumes?") -eq 0 ]]; then
            for volume in $volumes; do
                docker volume rm "${volume}"
            done
        else
            return 0
        fi
    else
        printf_callout "No matching volumes found."
    fi
}

function docker_ps() {
    docker ps "${@}" | less -RSFX
}

# Search tags on docker hub
function search_docker_tags() {
  name=$1

  # Initial URL
  url="https://registry.hub.docker.com/v2/repositories/library/${name}/tags/?page_size=100"

  (
    # Keep looping until the variable URL is empty
    while [ -n "${url}" ]; do
        # Every iteration of the loop prints out a single dot to show progress as
        # it got through all the pages (this is inline dot)
        >&2 printf "%s" "."

        # Curl the URL and pipe the output to Python. Python will parse the JSON
        # and print the very first line as the next URL (it will leave it blank
        # if there are no more pages)
        #
        # then continue to loop over the results extracting only the name; all
        # will be stored in a variable called content
        content=$(curl -s "${url}" \
            | python -c "$(sed -E "s/^ *//" <(printf "%s" '
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
    done;

    # Finally break the line of dots
    >&2 echo
  ) | cut -d '-' -f 1 | sort --version-sort | uniq;
}

function docker_select_image() {

  # Get list of running containers
  containers=$(docker ps --format="{{.ID}}")

  if [[ -z "$containers" ]]; then
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
    if [[ ${1} =~ 'help' ]]; then
        printf "%s\n" \
            "Docker helper to connect to a running container" \
            "" \
            "    Usage: de <container> [<command>]"
        return 1
    elif [[ $# -eq 0 ]]; then
        printf "%s\n" "Select a container"
        docker_select_image
    else
        docker exec -ti "$@"
    fi
}
