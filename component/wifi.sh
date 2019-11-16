#!/bin/bash

set -euo pipefail

wifi(){
    declare wifi_icon
    declare ssid=$(netctl list|grep "\*"|grep -oP "(?<=wlp2s0-).*")
    if [[ ${ssid} == "" ]]; then
        wifi_icon="^fn(SF Mono-22)^fn()"
    else
        wifi_icon="^fn(SF Mono-22)^fn()"
    fi
    echo -e "${wifi_icon} ${ssid}"
}

main(){
    declare monitor=${1:-0}
    wifi | dzen2 -fn "SF Mono-16" -h 27 -p -xs $((monitor+1))
}

[[ "$0" == "$BASH_SOURCE" ]] && main "$@" || true
