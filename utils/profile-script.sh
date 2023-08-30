#! /usr/bin/env bash

if [[ -z $1 ]]; then
    printf "%s\n" "USAGE: $(basename "${BASH_SCRIPT[0]}") <file>"
fi

SCRIPT_TO_PROFILE=$1
LOG_FILE="${SCRIPT_TO_PROFILE}.log"

# shellcheck disable=SC1090,SC1091
source "${HOME}/.dotfiles/bash-helpers/lib.sh"

rm -rf /tmp/profile.log /tmp/profile.tim

exec 3>&2 2> >(tee /tmp/profile.log |
    sed -u 's/^.*$/now/' |
    date -f - +%s.%N >/tmp/profile.tim)
set -x

for ((i=3; i--;))
do
    sleep .1
done

for ((i=2; i--;))
do
    printf_callout "Profiling ${SCRIPT_TO_PROFILE}"

    # shellcheck disable=SC1090
    source "${SCRIPT_TO_PROFILE}"
    printf "\n\n" >| "./${LOG_FILE}"
    printf "%s\n" "***** PROFILING START *****" >> "./${LOG_FILE}"
done

set +x
exec 2>&3 3>&-

paste <(
    while read -r tim ;do
        [ -z "$last" ] && last=${tim//.} && first=${tim//.}
        crt=000000000$((${tim//.}-10#0$last))
        ctot=000000000$((${tim//.}-10#0$first))
        printf "%12.9f %12.9f\n" ${crt:0:${#crt}-9}.${crt:${#crt}-9} \
                                 ${ctot:0:${#ctot}-9}.${ctot:${#ctot}-9}
        last=${tim//.}
    done < /tmp/profile.tim
) /tmp/profile.log >> "./${LOG_FILE}"

printf_callout "Log saved to ./${LOG_FILE}"
