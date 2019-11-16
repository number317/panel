#!/bin/bash

set -euo pipefail

volume(){
    declare volume_icon
    declare volume_status=$(pactl list sinks | grep -oP "(?<=Mute: )[a-z]*")
    declare volume=$(pactl list sinks | grep "^[[:blank:]]*Volume:"|grep  -o "[0-9]*%"|head -n 1|tr -d "%")
    [[ $volume -ge 100 ]] && volume=100 && pactl set-sink-volume 0 100%
    [[ $volume -le 2 ]] && volume=0 && pactl set-sink-volume 0 0%
    if [[ ${volume_status} == "yes" ]]; then
        volume_icon="^ca(1,pactl set-sink-mute 0 toggle;[[ -e /tmp/panel.pipe ]] && echo -e 'volume\t' >> /tmp/panel.pipe)^fn(SF Mono-22)婢^fn()^ca()"
    else
        volume_icon="^ca(1,pactl set-sink-mute 0 toggle;[[ -e /tmp/panel.pipe ]] && echo -e 'volume\t' >> /tmp/panel.pipe)^fn(SF Mono-22)^fn()^ca()"
    fi
    echo -en "${volume}% ${volume_icon} "
    echo -e "^ca(4,pactl set-sink-volume 0 +1%;[[ -e /tmp/panel.pipe ]] && echo -e 'volume\t' >> /tmp/panel.pipe)^ca(5,pactl set-sink-volume 0 -1%;[[ -e /tmp/panel.pipe ]] && echo -e 'volume\t' >> /tmp/panel.pipe)^fg(lightgrey)^ro(${volume}x2)^fg()^r(2x12)^fg(darkgrey)^r($[100-volume]x2)^fg()^ca()^ca()"
}

main(){
    declare monitor=$1
    declare pipe="/tmp/panel.pipe"
    trap "echo clean && rm $pipe" 2 9 15
    IFS=$'\t'
    [[ ! -e $pipe ]] && mkfifo $pipe
    {
        volume
        while read -ra event < $pipe; do
            if [[ event[0]=="volume" ]]; then
                volume
            fi
        done
    } | dzen2 -fn "SF Mono-16" -h 27 -p -xs $((monitor+1))
}

[[ "$0" == "$BASH_SOURCE" ]] && main "$@" || true
