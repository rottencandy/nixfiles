# avoid duplicating paths inside tmux
if [[ -z $TMUX ]]; then
    # extra binary locations
    test -s ~/bin              && export PATH="${HOME}/bin:${PATH}"
    test -s ~/.scripts         && export PATH="${HOME}/.scripts:${PATH}"
    test -s ~/.cargo/bin       && export PATH="${HOME}/.cargo/bin:${PATH}"
    test -s /opt/homebrew/bin  && export PATH="/opt/homebrew/bin:${PATH}"
    test -s ~/.node_caches/bin && export PATH="${HOME}/.node_caches/bin:${PATH}"
    test -s ~/.npm-global/bin  && export PATH="${HOME}/.npm-global/bin:${PATH}"
fi

# Colors with less
# from: https://wiki.archlinux.org/index.php/Color_output_in_console#man
export LESS_TERMCAP_mb=$'\e[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\e[1;33m'     # begin blink
export LESS_TERMCAP_so=$'\e[01;44;37m' # begin reverse video
export LESS_TERMCAP_us=$'\e[01;37m'    # begin underline
export LESS_TERMCAP_me=$'\e[0m'        # reset bold/blink
export LESS_TERMCAP_se=$'\e[0m'        # reset reverse video
export LESS_TERMCAP_ue=$'\e[0m'        # reset underline

export N_PREFIX=~/.node_caches

# NNN
# ---
# TODO: manage this in home-manager config
export NNN_CONTEXT_COLORS='2674'
#export NNN_PLUG='e:-_vim $nnn*;n:-_vim notes*;f:fzcd;u:-getplugs;r:-launch'
#export NNN_BMS='v:~/Videos;d:~/Documents;D:~/Downloads'
#export NNN_OPENER="open"
[ -n "$NNNLVL" ] && PS1="N$NNNLVL $PS1"

# Broot
# install this with broot --install
[ -s ~/.config/broot/launcher/bash/br ] && source ~/.config/broot/launcher/bash/br


# nnn with cd on quit
n() {
    # Block nesting of nnn in subshells
    if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi

    # To cd on quit only on ^G, remove the "export"
    # NOTE: NNN_TMPFILE is fixed, should not be modified
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    nnn -crA "$@"

    if [ -f "$NNN_TMPFILE" ]; then
        . "$NNN_TMPFILE"
        rm -f "$NNN_TMPFILE" > /dev/null
    fi
}

# yazi with cd on quit
y() {
    tmp="$(mktemp -t "yazi-cwd.XXXXX")"
    yazi --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# do sudo, or sudo the last command if no argument given
s() {
    if [[ $# == 0 ]]; then
        echo sudo $(history -p '!!')
        sudo $(history -p '!!')
    else
        sudo "$@"
    fi
}

# https://gist.github.com/pcdv
g() {
    local HLP="Bookmark your favorite directories:
    g         : list bookmarked dirs
    g .       : add current dir to bookmarks
    g -e      : edit bookmarks
    g <num>   : jump to n-th dir
    g <regex> : jump to 1st matching dir"
    local D=_; local CFG="$HOME/.cdirs"

    case $1 in
        #"") [ -f "$CFG" ] && nl "$CFG" || echo "$HLP" ;;
        "") [ -f "$CFG" ] && D=$(cat "$CFG" | fzf) || D=_ ;;
        .) pwd >> "$CFG" ;;
        -e) ${EDITOR:-vi} "$CFG" ;;
        -*) echo "$HLP" ;;
        [1-9]*) D=$(sed -ne "${1}p" "$CFG") ;;
        *) D=$(grep "$1" "$CFG" | head -1) ;;
    esac

    if [ "$D" != _ ]; then
        [ -d "$D" ] && cd "$D" || echo "Not found"
    fi
}

# Move up $ARGS directories (default 1)
up() {
    local d=""
    local limit="$1"

    # Default to limit of 1
    if [ -z "$limit" ] || [ "$limit" -le 0 ]; then
        limit=1
    fi

    for ((i = 1; i <= limit; i++)); do
        d="../$d"
    done

    # perform cd. Show error if cd fails
    if ! cd "$d"; then
        echo "Couldn't go up $limit dirs."
    fi
}

# vim: ts=4 sw=4 sts=4 et fdm=marker fdl=0:
