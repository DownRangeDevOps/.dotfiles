# shellcheck shell=bash

# Get pods using a selector
function kgps() {
    kubectl get pods --selector="$1" "${@:2}"
}

# Get all resources in a namespace
function kga() {
    local ns="${1:-default}"
    kubectl get all --namespace "$ns"
}

# Quickly switch context and namespace
function kuse() {
    if [ -n "$1" ]; then
        kubectl config use-context "$1"
    fi

    if [ -n "$2" ]; then
        kubectl config set-context --current --namespace="$2"
    fi
}

# Monitor pods with a specific label
function kwatch() {
    kubectl get pods -l "$1" --watch "${@:2}"
}

# Execute command in the first pod matching a pattern
function kexec() {
    local pod
    pod=$(kubectl get pods | grep "$1" | head -n 1 | awk '{print $1}')

    if [ -z "$pod" ]; then
        echo "No pod matching pattern: $1"
        return 1
    fi

    kubectl exec -it "$pod" -- "${@:2}"
}

# Tail logs from all pods matching a pattern
function klogsall() {
    kubectl get pods | grep "$1" | awk '{print $1}' | xargs -I{} kubectl logs -f {} "${@:2}"
}

# Get a shell in a temporary debug pod
function kdebug() {
    local image="${1:-busybox}"
    kubectl run -it --rm debug --image="$image" -- sh
}
