#! /usr/bin/env bash

SCRIPT_PATH=$1
SCRIPT_NAME="$(basename "$SCRIPT_PATH.log")"

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
    # shellcheck disable=SC1090
    source "${SCRIPT_PATH}"
    printf "%s\n" "***** PROFILING START *****" >| "${SCRIPT_NAME}"
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
) /tmp/profile.log >> "${SCRIPT_NAME}"
