# shellcheck disable=SC1090,SC1091  # ignore refusal to follow dynamic paths

# - We should not use unbound variables
# - We should ensure pipelines fail if commands within them fail
set -uo pipefail

# Setup shell
source "${HOME}/.dotfiles/bash-helpers/bash_profile.sh"
