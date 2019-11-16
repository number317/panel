#!/bin/bash

set -euo pipefail

battery(){
    declare battery_icons=( "" "" "" "" "" "" "" "" "" "" "" "" )

    declare percent=$(cat /sys/class/power_supply/BAT0/capacity)
    declare battery_icon
    [[ $percent -gt 100 ]] && percent=100
    [[ $percent -le 20 ]] && fg_color="#ff0000"
    declare status=$(cat /sys/class/power_supply/BAT0/status)
    case $status in
        Full|Charging)
            battery_icon=${battery_icons[11]}
            ;;
        *)
            battery_icon=${battery_icons[$((percent/10))]}
            
    esac
    echo -e "${battery_icon} ${percent}%"
}

main(){
    battery    
}

[[ "$0" == "$BASH_SOURCE" ]] && main "$@" || true
