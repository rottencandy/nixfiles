{
  config,
  lib,
  pkgs,
  ...
}:

let

  is_arm_macos = pkgs.system == "aarch64-darwin";
in
{
  programs.bash = {
    enable = true;
    shellOptions = [
      "autocd" # cd on dir name
      "checkwinsize" # update LINES and COLUMNS on window resize
      "cmdhist" # combine multiline commands into one
      "histappend" # append to $HISTFILE instead of overwriting it
      "globstar"
      "extglob" # enable extra pattern matching
      "nullglob"
      #"cdspell" # automatically correct minor typos with dir names
    ];
    # remove duplicates & ignore commands starting with space
    historyControl = [
      "ignorespace"
      "ignoredups"
      "erasedups"
    ];
    # do not save these in history
    historyIgnore = [
      "g"
      "s"
      "n"
      "l"
      "t"
      "y"
      "cd"
      "fg"
      "gd"
      "ls"
      "ll"
      "la"
      "nn"
      "nv"
      "shl"
    ];

    shellAliases =
      {
        # TODO get advcpmv to nixpkgs
        gd = "DELTA_NAVIGATE=1 git diff";
        gr = "cd ./$(git rev-parse --show-cdup)";
        k = "kubectl";
        ls = "lsd";
        l = "lsd -F";
        la = "lsd -A";
        ll = "lsd -l";
        nv = "nvim";
        nvdaemon = "nvim --headless --listen localhost:6666";
        t = "tmux";
        tree = "lsd --tree";
        gron = "fastgron";
        ungr = "fastgron --ungron";
        kc = "keepassxc-cli";
        # -X is probably not used in macos
        v = "vim -X";
        yt = "yt-dlp --add-metadata -i";
        ytb = "yt-dlp --add-metadata -i -f bestvideo+bestaudio";
        yta = "yt --add-metadata -x -f bestaudio";
        brownnoise = "play -n synth brownnoise synth pinknoise mix synth sine amod 0.3 10";
        whitenoise = "play -q -c 2 -n synth brownnoise band -n 1600 1500 tremolo .1 30";
        pinknoise = "play -t sl -r48000 -c2 -n synth -1 pinknoise .1 80";
      }
      // (
        if is_arm_macos then
          { }
        else
          {
            camfeed = "gst-launch-1.0 -v v4l2src device=/dev/video0 ! glimagesink";
            scrt = "grim -g \"$(slurp)\" screenshot-$(date +%s).png 2> /dev/null";
            srec = "wf-recorder -g \"$(slurp)\" -c h264_vaapi -d /dev/dri/renderD128 -f recording-$(date +%s).mp4";
            arec = "parec --monitor-system = \"$(pacmd get-default-source)\" --file-format = \"wav\" recording-$(date +%s).wav";
          }
      );

    bashrcExtra = lib.strings.fileContents ./bashExtra.sh;
  };

  # scripts dir
  home.file = {
    ".scripts" = {
      source = ./scripts;
      executable = true;
    };
  };

  # env vars
  home.sessionVariables = {
    EDITOR = "nvim";
    GIT_EDITOR = "nvim";
    SVN_EDITOR = "nvim";
    KUBE_EDITOR = "nvim";
    VISUAL = "nvim";
    #BROWSER = "/usr/bin/firefox";

    LESS = "--mouse --wheel-lines=3"; # mouse support for less
    GROFF_NO_SGR = 1; # for konsole and gnome-terminal
    MANPAGER = "less -s -M +Gg"; # percentage FTW
    PAGER = "less -s -M +Gg";

    # colored GCC warnings and errors
    GCC_COLORS = "error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01";
  };
}

# vim: fdm=marker:fdl=0:et:sw=2
