{ config, lib, pkgs, ... }:

let
  # Script to run processes using discrete Nvidia GPU
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';

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

  # Toggle all hyprland animations & visuals for performance
  hyprland-perf = pkgs.writeShellScriptBin "hyperf" ''
  HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==2{print $2}')
  if [ "$HYPRGAMEMODE" = 1 ] ; then
      hyprctl --batch "\
          keyword animations:enabled 0;\
          keyword decoration:drop_shadow 0;\
          keyword decoration:blur:enabled 0;\
          keyword general:gaps_in 0;\
          keyword general:gaps_out 0;\
          keyword general:border_size 1;\
          keyword decoration:rounding 0"
      exit
  fi
  hyprctl reload
  '';

  # nix-alien to run non-NixOS binaries in a compatible FHS environment with
  # all needed shared dependencies
  nix-alien-pkgs = import (
    builtins.fetchTarball "https://github.com/thiagokokada/nix-alien/tarball/master"
  ) { };

in
{
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # tools
    ffmpeg
    gparted
    pandoc
    delta
    emacs
    rio
    helix
    tmux
    neofetch
    xh
    fd
    bat
    nnn
    yazi
    broot
    bottom
    htop
    lsd
    jq
    jless
    yt-dlp
    vim
    neovim
    wget
    curl
    moreutils
    ripgrep
    pass
    clang
    mold
    pinentry
    todo-txt-cli
    dwarfs
    fuse-overlayfs
    nix-alien-pkgs.nix-alien

    # shell functions
    git-glog
    pass-get
    hyprland-perf

    # applications
    qbittorrent
    vlc
    mpv
    feh
    gimp
    lutris
    heroic
    hexchat
    neovide
    bottles
    firefox
    godot_4
    zathura

    # utils
    asusctl
    nvidia-offload
    steam-run
    nvtop
    protonup-qt
    gamescope
    redshift
    openvpn
    brightnessctl
    unrar
    wev
    sox
    blueman

    # languages
    rustup

    # WM
    wineWowPackages.waylandFull
    winetricks
    xdg-desktop-portal-hyprland
    hyprland
    hyprpaper
    wdisplays
    wf-recorder
    wl-clipboard
    fuzzel
    mako
    swaylock
    swayidle
    grim
    slurp
    kanshi

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;
    ".tmux.conf".source = ./tmux.conf;
    ".config/sway/config".source = ./sway.config;
    ".config/waybar" = {
      source = ./waybar;
      recursive = true;
    };
    ".config/nvim/init.vim".source = ./init.vim;
    ".config/hypr/hyprland.conf".source = ./hyprland.conf;
    ".config/hypr/hyprpaper.conf".source = ./hyprpaper.conf;
    ".vim" = {
      source = ./vim;
      recursive = true;
    };
    ".todo.cfg".source = ./todo.cfg;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/saud/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "vim";
    GIT_EDITOR = "vim";
    SVN_EDITOR = "vim";
    KUBE_EDITOR = "vim";
    VISUAL = "vim";
  };

  # Let Home Manager install and manage itself.
  #programs.home-manager.enable = true;

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
      #acp = "cpg -g";
      #amv = "mvg -g";
      gd = "DELTA_NAVIGATE = 1 git diff";
      gr = "cd ./$(git rev-parse --show-cdup)";
      k = "kubectl";
      l = "ls -CF";
      la = "lsd -A";
      ll = "lsd -l";
      nb = "cd ~/nb && nvim -c \"exec \\\"normal 1 f\\";
      nv = "nvim";
      nvdaemon = "nvim --headless --listen localhost:6666";
      scrt = "grim -g \"$(slurp)\" screenshot-$(date +%s).png 2> /dev/null";
      srec = "wf-recorder -g \"$(slurp)\" -c h264_vaapi -d /dev/dri/renderD128 -f recording-$(date +%s).mp4";
      arec = "parec --monitor-system = \"$(pacmd get-default-source)\" --file-format = \"wav\" recording-$(date +%s).wav";
      t = "tmux";
      tree = "lsd --tree";
      ungr = "gron --ungron";
      v = "vim -X";
      yt = "yt-dlp --add-metadata -i";
      ytb = "yt-dlp --add-metadata -i -f bestvideo+bestaudio";
      yta = "yt --add-metadata -x -f bestaudio";
      camfeed = "gst-launch-1.0 -v v4l2src device = /dev/video0 ! glimagesink";
      brownnoise = "play -n synth brownnoise synth pinknoise mix synth sine amod 0.3 10";
      whitenoise = "play -q -c 2 -n synth brownnoise band -n 1600 1500 tremolo .1 30";
      pinknoise = "play -t sl -r48000 -c2 -n synth -1 pinknoise .1 80";
    };

    bashrcExtra = ''
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

  # kanshi, ripgrep, hyprland do not exist on stable branch of home-manager yet :/

  #programs.kanshi = {
  #  enable = true;
  #  profiles = {
  #    default = {
  #      outputs = {
  #        "HDMI-A-1" = {
  #          mode = "1920x1080@74.973";
  #          position = "0,0";
  #        };
  #        "eDP-1" = {
  #          position = "1920,0";
  #        };
  #      };
  #    };
  #    default2 = {
  #      outputs = {
  #        "HDMI-A-2" = {
  #          mode = "1920x1080@74.973";
  #          position = "0,0";
  #        };
  #        "eDP-1" = {
  #          position = "1920,0";
  #        };
  #      };
  #    };
  #  };
  #};

  #programs.ripgrep = {
  #  enable = true;
  #  arguments = [
  #    "--smart-case"
  #    #"--hidden"
  #    "--glob"
  #    "!.git"
  #  ];
  #};

  # hyprland config
  #wayland.windowManager.hyprland = {
  #  enable = true;
  #  settings = {
  #    # use integrated GPU by default
  #    env = "WLR_DRM_DEVICES,/dev/dri/card0:/dev/dri/card1";
  #    "$mod" = "SUPER";
  #    bind = [
  #      "$mod, ENTER, exec, wezterm"
  #      "$mod, D, exec, fuzzel"
  #    ];
  #  };
  #};

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        height = 30;
        spacing = 4;
        modules-left = [ "hyprland/workspaces" ];
        #modules-center = [ "hyprland/window" ];
        modules-right = [ "idle_inhibitor" "network" "cpu" "memory" "temperature" "battery" "clock" "tray" ];
        keyboard-state = {
          numlock = true;
          capslock = true;
        };
        clock = {
          # timezone = "America/New_York";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format = "{:%I:%M}";
          format-alt = "{:%h %d}";
        };
      };
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
      hide_tab_bar_if_only_one_tab = true,
    }
    '';
  };

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };
}