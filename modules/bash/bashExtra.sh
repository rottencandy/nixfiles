test -s /opt/homebrew/bin  && export PATH="/opt/homebrew/bin:''${PATH}"
test -s ~/bin              && export PATH="''${HOME}/bin:''${PATH}"
test -s ~/.node_caches/bin && export PATH="''${HOME}/.node_caches/bin:''${PATH}"

export N_PREFIX=~/.node_caches

# nnn with cd on quit
n() {
    # Block nesting of nnn in subshells
    if [ -n $NNNLVL ] && [ "''${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi

    # To cd on quit only on ^G, remove the "export"
    # NOTE: NNN_TMPFILE is fixed, should not be modified
    export NNN_TMPFILE="''${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

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
        -e) ''${EDITOR:-vi} "$CFG" ;;
        -*) echo "$HLP" ;;
        [1-9]*) D=$(sed -ne "''${1}p" "$CFG") ;;
        *) D=$(grep "$1" "$CFG" | head -1) ;;
    esac

    if [ "$D" != _ ]; then
        [ -d "$D" ] && cd "$D" || echo "Not found"
    fi
}

# vim: ts=4 sw=4 sts=4 et fdm=marker fdl=0:
