#! /usr/bin/env bash
# https://stackoverflow.com/questions/5014823/how-can-i-profile-a-bash-shell-script-slow-startup/20855353#20855353

if [[ -z $1 ]]; then
    printf "%s\n" "USAGE: $(basename "${BASH_SCRIPT[0]}") <file>"
fi

SCRIPT_TO_PROFILE=$1
LOG_FILE="${SCRIPT_TO_PROFILE}.log"

rm -rf /tmp/profile.log /tmp/profile.tim

# Redirect stderr to &3
#   - generate a timestamp for each line of &3 in .tim file
#   - tee stderr output to .log file
exec 3>&2 2> >(tee /tmp/profile.log |
    sed -u 's/^.*$/now/' |
    date -f - +%s.%N >/tmp/profile.tim)

printf "%s\n" "***** PROFILING START *****" >> "./${LOG_FILE}"

# for ((i=2; i--;))
# do
#     # shellcheck disable=SC1090
#     source "${SCRIPT_TO_PROFILE}"
# done

# Start profiling
set -x

for ((i=3; i--;))
do
    sleep .1
done


# shellcheck disable=SC1090
source "${SCRIPT_TO_PROFILE}"

set +x
exec 2>&3 3>&-

# Unify .tim entries with .log entries
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
