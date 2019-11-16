#!/bin/bash

set -euo pipefail

# mpc idleloop, how to start when mpd inactive
music(){
    declare mpc_status
    declare control
    if [[ $(systemctl is-active mpd) == "active" ]]; then
        mpc_status=$(mpc | grep -oP "(?<=\[)[a-z]*(?=\])")
        if [[ ${mpc_status} == "playing" ]]; then
            control="^ca(1, mpc prev &>/dev/null;[[ -e /tmp/panel.pipe ]] && echo -e 'player\t' >> /tmp/panel.pipe)玲^ca() ^ca(1, mpc toggle &>/dev/null;[[ -e /tmp/panel.pipe ]] && echo -e 'player\t' >> /tmp/panel.pipe)^ca() ^ca(1, mpc next &>/dev/null;[[ -e /tmp/panel.pipe ]] && echo -e 'player\t' >> /tmp/panel.pipe)怜^ca()"
        else
            control="^ca(1, mpc prev &>/dev/null;[[ -e /tmp/panel.pipe ]] && echo -e 'player\t' >> /tmp/panel.pipe)玲^ca() ^ca(1, mpc toggle &>/dev/null;[[ -e /tmp/panel.pipe ]] && echo -e 'player\t' >> /tmp/panel.pipe)^ca() ^ca(1, mpc next &>/dev/null;[[ -e /tmp/panel.pipe ]] && echo -e 'player\t' >> /tmp/panel.pipe)怜^ca()"
        fi
        echo "^ca(1,[[ -e /tmp/panel.pipe ]] && echo -e 'player\t' >> /tmp/panel.pipe)^fn(SF Mono-16)ﱘ^fn()^ca() ^fn(PingFang SC-12)$(mpc current 2>/dev/null)^fn() ${control}"
    else
        echo "^ca(1,[[ -e /tmp/panel.pipe ]] && echo -e 'player\t' >> /tmp/panel.pipe)^fn(SF Mono-16)ﱙ^fn()^ca()"
    fi
}

main(){
    declare monitor=${1:-0}
    declare pipe="/tmp/panel.pipe"
    declare mpd_init_state=$(systemctl is-active mpd)
    trap "echo clean && rm $pipe" 2 9 15
    IFS=$'\t'
    [[ ! -e $pipe ]] && mkfifo $pipe
    [[ ${mpd_init_state} == "active" ]] && mpc idleloop >> "$pipe" &
    {
        music
        if [[ ${mpd_init_state} == "inactive" ]]; then
            pgrep mpc || mpc idleloop >> "$pipe" &
        fi
        while read -ra event < $pipe; do
            if [[ event[0]=="player" ]]; then
                music
            fi
        done
    } | dzen2 -fn "SF Mono-16" -h 27 -p -xs $((monitor+1))
}

[[ "$0" == "$BASH_SOURCE" ]] && main "$@" || true
