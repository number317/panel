#!/bin/bash

set -euo pipefail

for sh in ~/Codes/panel/component/*; do
    source "$sh"
done

cleanup(){
    declare monitor=$1
    echo "receive quit signal"
    herbstclient pad $monitor 0
    exec 6>&-
    rm "$name_pipe"
    pkill -9 dzen2
    wait
    exit 0
}

uniq_linebuffered() {
    awk '$0 != l { print ; l=$0 ; fflush(); }' "$@"
}

# main
monitor=${1:-0}
trap "cleanup $monitor" 2 9 15

name_pipe="/tmp/panel.pipe"

rm -f $name_pipe && mkfifo "$name_pipe"
exec 6<>"$name_pipe"

geometry=( $(herbstclient monitor_rect "$monitor") )
if [ -z "$geometry" ] ;then
    echo "Invalid monitor $monitor"
    exit 1
fi
# geometry has the format W H X Y
x=${geometry[0]}
y=${geometry[1]}

# init status
tags="$(tag $monitor)"
title=""
input="$(input)"
song="$(music)"
wifi=""
volume=""
power=""
time=""

herbstclient pad $monitor 27
{
    echo -en "input\t"
    input

    echo -en "wifi\t"
    wifi

    echo -en "volume\t"
    volume

while true; do
    echo -en "power\t"
    battery
    sleep 2 || break
done > >(uniq_linebuffered) &

while true ; do
    date +$'time\t^fn(SF Mono-20)^fn() %H:%M ^fn(SF Mono-20)^fn() %Y-%m-%d '
    sleep 1 || break
done > >(uniq_linebuffered) &

herbstclient --idle &

[[ $(systemctl is-active mpd) == "active" ]] && mpc idleloop &

} >> $name_pipe

while true; do
    IFS=$'\t' read -u6 -r -a event || break
    case "${event[0]}" in
        tag*)
            tags="$(tag $monitor)"
            ;;
        focus_changed|window_title_changed)
            if [[ ${#event[@]} -ge 3 ]]; then
                title="^fn(PingFang SC-12)${event[2]}^fn()"
            else
                title=""
            fi
            ;;
        input)
            input=$(input)
            ;;
        player)
            song=$(music)
            ;;
        wifi)
            wifi=$(wifi)
            ;;
        volume)
            volume=$(volume)
            ;;
        power)
            power=${event[1]}
            ;;
        time)
            time=${event[1]}
            ;;
    esac
    echo -e "${tags} ${title}^p(_CENTER)${input} ${song} ${wifi} ${volume} ${power} ${time}^p()"
done | dzen2 -p -h 27 -dock -fn "SF Mono-12" -xs $((monitor+1)) -e "button2=exit;button3=togglehide" -ta c
