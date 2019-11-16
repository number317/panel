#!/bin/bash

set -euo pipefail

launcher(){
    echo -en "^bg(#d8dee9)^fg(#2e3440)^fn(SF Mono-20)"
    echo -en "^ca(1,firefox) \uf269 ^ca()"
    echo -en "^ca(1,libreoffice) \uf8c5 ^ca()"
    echo -en "^ca(1,urxvtc -e ranger) \uf413 ^ca()"
    echo -en "^ca(1,urxvtc) \ue795 ^ca()"
    echo -en "^ca(1,gvim) \ue7c5 ^ca()"
    echo -en "^ca(1,urxvtc -e irssi) \uf683 ^ca()"
    echo -en "^ca(1,urxvtc -e mutt) \uf6ed ^ca()"
    echo -en "^fn()^fg()^bg()"
    echo
}

main(){
    launcher | dzen2 -p -fn "SF Mono-20" -h 27
}

[[ "$0" == "$BASH_SOURCE" ]] && main "$@" || true

