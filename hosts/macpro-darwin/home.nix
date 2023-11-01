{ config, lib, pkgs, ... }:

let
  git-glog = pkgs.writeShellScriptBin "glog" ''
    setterm -linewrap off

    git --no-pager log --all --color=always --graph --abbrev-commit --decorate \
        --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' | \
        sed -E \
        -e 's/\|(\x1b\[[0-9;]*m)+\\(\x1b\[[0-9;]*m)+ /├\1─_\2/' \
        -e 's/(\x1b\[[0-9;]+m)\|\x1b\[m\1\/\x1b\[m /\1├─_\x1b\[m/' \
        -e 's/\|(\x1b\[[0-9;]*m)+\\(\x1b\[[0-9;]*m)+/├\1_\2/' \
        -e 's/(\x1b\[[0-9;]+m)\|\x1b\[m\1\/\x1b\[m/\1├_\x1b\[m/' \
        -e 's/_(\x1b\[[0-9;]*m)+\\/_\1__/' \
        -e 's/_(\x1b\[[0-9;]*m)+\//_\1__/' \
        -e 's/(\||\\)\x1b\[m   (\x1b\[[0-9;]*m)/__\2/' \
        -e 's/(\x1b\[[0-9;]*m)\\/\1_/g' \
        -e 's/(\x1b\[[0-9;]*m)\//\1_/g' \
        -e 's/^\*|(\x1b\[m )\*/\1_/g' \
        -e 's/(\x1b\[[0-9;]*m)\|/\1│/g' \
        | command less -r +'/[^/]HEAD'

    setterm -linewrap on
  '';

  # Grab a password from the password store into the clipboard using fzf
  pass-get = pkgs.writeShellScriptBin "getp" ''
    PASS_DIR=~/.password-store
    selection=$(cd $PASS_DIR && fd --type f | fzf)
    if [ -z $selection ]; then return; fi
    pass -c "''${selection//.gpg/}"
  '';

in
{
  home.username = "msaud";
  home.homeDirectory = "/Users/msaud";

  home.packages = with pkgs; [
    # applications
    neovim
    neovide
    #macvim
    emacs
    iterm2
    qbittorrent
    feh
    gimp
    zathura
    #cmus
    #freetube
    #uxn
    mpv

    # mac
    #karabiner-elements
    #goku
    m-cli
    iina
    monitorcontrol
    aldente
    skhd
    unnaturalscrollwheels

    # utils
    git
    tmux
    delta
    gnupg
    pass
    ffmpeg
    pandoc
    todo-txt-cli
    wgcf
    ffsend

    macchina
    bottom
    curl
    wget
    lsd
    jq
    jless
    jo
    fastgron
    ripgrep
    xh
    fd
    bat
    nnn
    yazi
    broot
    ripdrag
    moreutils

    yt-dlp
    unrar
    sox

    # dev
    rustup
    mold
    lima
    utm
    #quickemu
    qemu
    podman
    podman-tui

    # shell functions
    git-glog
    pass-get
  ];

  #programs.rio = {
  #  enable = true;
  #  settings = {
  #    theme = "gruvboxDark";
  #  };
  #};

  home.file = {
    ".tmux.conf".source = ../../home/tmux.conf;
    ".config/nvim/init.vim".source = ../../home/init.vim;
    ".vim" = {
      source = ../../home/vim;
      recursive = true;
    };
    ".todo.cfg".source = ../../home/todo.cfg;
    ".config/skhd/skhdrc".text = ''
      cmd - return : wezterm
      cmd + shift - r : yabai -restart-service

      cmd - h : yabai -m window --focus west
      cmd - j : yabai -m window --focus south
      cmd - k : yabai -m window --focus north
      cmd - l : yabai -m window --focus east

      cmd + shift - h : yabai -m window --warp west
      cmd + shift - j : yabai -m window --warp south
      cmd + shift - k : yabai -m window --warp north
      cmd + shift - l : yabai -m window --warp east

      # requires scripting addition
      cmd - 1 : yabai -m space --focus 1
      cmd - 2 : yabai -m space --focus 2
      cmd - 3 : yabai -m space --focus 3
      cmd - 4 : yabai -m space --focus 4
      cmd - 5 : yabai -m space --focus 5

      # monitor focus, requires display number
      cmd + ctrl - l : yabai -m display --focus 1
      cmd + ctrl - h : yabai -m display --focus 2

      cmd + shift - 1 : yabai -m window --space 1; yabai -m space --focus 1
      cmd + shift - 2 : yabai -m window --space 2; yabai -m space --focus 2
      cmd + shift - 3 : yabai -m window --space 3; yabai -m space --focus 3
      cmd + shift - 4 : yabai -m window --space 4; yabai -m space --focus 4
      cmd + shift - 5 : yabai -m window --space 5; yabai -m space --focus 5

      cmd - m : yabai -m window --toggle zoom-parent
      cmd - f : yabai -m window --toggle zoom-fullscreen
      cmd - v : yabai -m window --toggle split
      cmd + shift - space : yabai -m window --toggle float --grid 4:4:1:1:2:2
    '';
    ".config/yabai/yabairc" = {
      text = ''
        #!/usr/bin/env sh

        yabai -m config layout bsp
        yabai -m config top_padding 16
        yabai -m config bottom_padding 16
        yabai -m config left_padding 16
        yabai -m config right_padding 16
        yabai -m config window_gap 8
        #yabai -m config focus_follows_mouse autoraise
        yabai -m config mouse_follows_focus on
        yabai -m config mouse_modifier cmd
        yabai -m config external_bar all:32:0
      '';
      executable = true;
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    GIT_EDITOR = "nvim";
    SVN_EDITOR = "nvim";
    KUBE_EDITOR = "nvim";
    VISUAL = "nvim";
  };

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
    # homebrew
    export PATH="/opt/homebrew/bin:''${PATH}"

    # misc binaries/scripts
    export PATH="''${HOME}/bin:''${PATH}"

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

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    defaultCommand = "fd --type f";
    defaultOptions = [
      "--multi"
      "--cycle"
      "--height 16"
      "--color=dark"
      "--layout=reverse"
      "--prompt=' '"
      "--bind=ctrl-k:toggle-preview"
    ];
    tmux.enableShellIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      format = lib.concatStrings [
        "$directory"
        "$git_branch"
        "$cmd_duration"
        "$battery"
        "$sudo"
        "$container"
        "$line_break"
        "$character"
      ];
      add_newline = false;
      # wait time(in md) for starship to check files under current dir
      scan_timeout = 10;
      character = {
        success_symbol = "[󰘧](bold green) ";
        error_symbol = "[󰘧](bold red) ";
      };
      battery.display = [
        {
          threshold = 30;
          style = "bold yellow";
        }
        {
          threshold = 20;
          style = "bold red";
        }
      ];
      #[[battery.display]]
      #threshold = 20
      #style = 'bold red'

      directory = {
        truncation_length = 4;
        truncation_symbol = ".../";
        #fish_style_pwd_dir_length = "1";
      };

      git_branch = {
        #symbol = '__ '
        #truncation_length = 7
        #truncation_symbol = '...'
      };

      cmd_duration.format = " \\[[$duration]($style)\\] ";

      sudo.disabled = false;
    };
  };

  programs.git = {
    enable = true;
    delta = {
      enable = true;
      options = {
        "side-by-side" = true;
	"line-numbers" = true;
	navigate = true;
      };
    };
    userName = "Mohammed Saud";
    userEmail = "md.saud020@gmail.com";
    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      last = "log -1 HEAD";
      yoink = "reset --hard";
      # All unmerged commits after fetch
      lc = "log ORIG_HEAD.. --stat --no-merges";

      # log in local time
      llog = "log --date=local";

      # Fetch PR from upstream
      pr = "!f() { git fetch upstream pull/\${1}/head:pr\${1}; }; f";

      # Pretty log
      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";

      # Show current branch
      pwd = "symbolic-ref --short HEAD";
      # Show corresponding upstream branch
      upstream = "name-rev @{upstream}";

      # Set upstream before pushing if necessary
      pu = "!f() { if [ \"$(git upstream 2> /dev/null)\" ]; then git push; else git push -u origin $(git pwd); fi }; f";

      # Pull submodules
      pulsub = "submodule update --remote";
    };
    extraConfig = {
      # colorize output
      color = {
        diff = "auto";
        status = "auto";
        branch = "auto";
        interactive = "auto";
        ui = true;
        pager = true;
      };
      # cache credentials
      credential = {
        helper = "cache --timeout=3600";
      };
      merge = {
        conflictstyle = "diff3";
      };
      sendemail = {
        smtpEncryption = "tls";
        smtpServer = "smtp.gmail.com";
        smtpServerPort = "587";
        smtpUser = "md.saud020@gmail.com";
      };
      pull.rebase = true;
      filter.lfs = {
        clean = "git-lfs clean -- %f";
        smudge = "git-lfs smudge -- %f";
        process = "git-lfs filter-process";
        required = true;
      };
      init.defaultBranch = "main";
    };
  };

  programs.wezterm = {
    enable = true;
    extraConfig = ''
    local wezterm = require 'wezterm'

    return {
      font = wezterm.font 'FiraCode Nerd Font Mono',
      color_scheme = 'Afterglow',
      hide_tab_bar_if_only_one_tab = true,
    }
    '';
  };

  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = "23.05";
}

# vim: fdm=marker:fdl=0:et:sw=2
