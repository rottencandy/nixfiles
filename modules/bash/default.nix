{ config, lib, pkgs, ... }:

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
      "n"
      "cd"
      "ls"
      "ll"
      "nn"
      "nv"
      "gd"
    ];

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

    bashrcExtra = lib.strings.fileContents ./bashExtra.sh;
  };
}

# vim: fdm=marker:fdl=0:et:sw=2
