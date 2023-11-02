{ config, lib, pkgs, ... }:

{
  programs.bash = {
    enable = true;
    shellOptions = [
      "autocd" # cd on dir name
      "checkwinsize" # update LINES and COLUMNS on window resize
      "cmdhist" # combine multiline commands into one
      "histappend"
      "globstar"
      "extglob"
      "nullglob"
    ];
    # remove duplicates & ignore commands starting with space
    historyControl = [ "erasedups" "ignorespace" ];

    shellAliases = {
      # TODO get advcpmv to nixpkgs
      gd = "DELTA_NAVIGATE=1 git diff";
      gr = "cd ./$(git rev-parse --show-cdup)";
      k = "kubectl";
      l = "ls -CF";
      la = "lsd -A";
      ll = "lsd -l";
      nv = "nvim";
      nvdaemon = "nvim --headless --listen localhost:6666";
      t = "tmux";
      tree = "lsd --tree";
      ungr = "gron --ungron";
      v = "vim -X";
      yt = "yt-dlp --add-metadata -i";
      ytb = "yt-dlp --add-metadata -i -f bestvideo+bestaudio";
      yta = "yt --add-metadata -x -f bestaudio";
      brownnoise = "play -n synth brownnoise synth pinknoise mix synth sine amod 0.3 10";
      whitenoise = "play -q -c 2 -n synth brownnoise band -n 1600 1500 tremolo .1 30";
      pinknoise = "play -t sl -r48000 -c2 -n synth -1 pinknoise .1 80";
    };

    bashrcExtra = ''
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
    '';
  };
}

# vim: fdm=marker:fdl=0:et:sw=2
