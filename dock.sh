#!/bin/bash

set -euo pipefail
set -x

dock(){
    monitor=${1:-0}
    declare item=4
    declare geometry=( $(herbstclient monitor_rect) )
    declare height=108
    declare width=620
    declare pad=( $(herbstclient list_padding) )
    pad[2]=$(expr ${pad[2]} + $height)
    herbstclient pad $monitor ${pad[@]} 
    echo -e "^p(_CENTER)^ca(1,firefox)^ca()^p()\n \
        ^p(_CENTER)^ca(1,libreoffice)^ca()^p()\n \
        ^p(_CENTER)^ca(1,urxvtc -e ranger)^ca()^p()\n \
        ^p(_CENTER)^ca(1,urxvtc -e mutt)^ca()^p()" | dzen2 -l $item -m h -p -fn "SF Mono-90" -h $height -w $width -x $(expr ${geometry[2]} / 2 - $width / 2) -y ${geometry[3]} -xs $((monitor+1))
}

clear(){
    declare pad=( $(herbstclient list_padding) )
    pad[2]=$(expr ${pad[2]} - $height)
    herbstclient pad $monitor ${pad[@]} 
}

main(){
    declare monitor=${1:-0}
    trap clear 2 9 15
    dock $monitor
}

[[ "$0" == "$BASH_SOURCE" ]] && main "$@" || true

