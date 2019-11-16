#!/bin/bash
set -euo pipefail

tag(){
    declare monitor=$1
    declare -A tags_draw
    declare tags_draw=( [a]="" [b]="" [c]="" [d]="" [e]="" [f]="" [g]="" [h]="" [i]="" [j]="" )
    IFS=$'\t' read -ra tags <<< "$(herbstclient tag_status $monitor)"
    echo -n "^fn(SF Mono-20)"
    for i in "${tags[@]}" ; do
        case ${i:0:1} in
            '#')
                echo -n "^bg(#1ba784)^fg()"
                ;;
            '+')
                echo -n "^bg(#9CA668)^fg(#867018)"
                ;;
            ':')
                echo -n "^bg()^fg(#b0d5df)"
                ;;
            '!')
                echo -n "^bg(#FF0675)^fg(#d0deaa)"
                ;;
            *)
                echo -n "^bg()^fg(#ababab)"
                ;;
        esac
        echo -n "^ca(1,herbstclient focus_monitor \"$monitor\" && herbstclient use \"${i:1}\") ${tags_draw[${i:1}]} ^ca()^bg()^fg()"
    done
    echo -n "^fn()"
    echo
}

main(){
    [[ $# -ge 1 ]] && declare monitor=$1
    tag ${monitor:-0}
}

[[ "$0" == "$BASH_SOURCE" ]] && main "$@" || true
