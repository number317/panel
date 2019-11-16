#!/bin/bash
set -euo pipefail

input(){
    declare engine="En"
    if [[ $(pgrep -c ibus) -ne 0 ]]; then
        [[ $(ibus engine) == "rime" ]] && engine="^fn(PingFang SC-12)㞢^fn()"
    fi
    echo -e "^ca(1,[[ $(ibus engine) == 'rime' ]] && ibus engine xkb:us::eng || ibus engine rime; [[ -e /tmp/panel.pipe ]] && echo -e 'input\t' >> /tmp/panel.pipe; )${engine}^ca()"
}

main(){
    input
}

[[ "$0" == "$BASH_SOURCE" ]] && main "$@" || true
