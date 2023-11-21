{ config, lib, pkgs, ... }:

let
  # Grab a password from the password store into the clipboard using fzf
  pass-get = pkgs.writeShellScriptBin "getp" ''
    PASS_DIR=~/.password-store
    selection=$(cd $PASS_DIR && fd --type f | fzf)
    if [ -z $selection ]; then return; fi
    pass -c "''${selection//.gpg/}"
  '';

in
{
  imports = [
    ../../modules/vim
    ../../modules/bash
    ../../modules/tmux
    ../../modules/yabai
    ../../modules/git.nix
    ../../modules/fzf.nix
    ../../modules/sketchybar
    ../../modules/starship.nix
    ../../modules/tridactyl.nix
  ];

  home.username = "msaud";
  home.homeDirectory = "/Users/msaud";

  home.packages = with pkgs; [
    # applications
    emacs
    qbittorrent
    gimp
    zathura
    moc
    musikcube
    freetube
    #uxn
    mpv
    #quassel
    halloy
    nethack
    unnethack

    # mac
    #goku
    #monitorcontrol
    karabiner-elements
    m-cli
    aldente
    unnaturalscrollwheels

    # utils
    delta
    difftastic
    helix
    gnumake
    gnused
    gnupg
    pass
    ffmpeg
    imagemagick
    pandoc
    todo-txt-cli
    wgcf
    ffsend
    shellcheck

    macchina
    bottom
    curl
    wget
    lsd
    jq
    jless
    jo
    fx
    fastgron
    ripgrep
    xh
    fd
    bat
    nnn
    ripdrag
    moreutils

    yt-dlp
    unrar
    sox

    # dev
    rustup
    clang
    deno
    mold
    lima
    utm
    #quickemu
    qemu
    kubectl
    podman
    podman-tui
    tigervnc

    # shell functions
    pass-get
  ];

  #programs.rio = {
  #  enable = true;
  #  settings = {
  #    theme = "gruvboxDark";
  #  };
  #};

  home.file = {
    ".todo.cfg".source = ../../home/todo.cfg;
  };

  programs.wezterm = {
    enable = true;
    extraConfig = ''
    local wezterm = require 'wezterm'

    return {
      font = wezterm.font 'FiraCode Nerd Font Mono',
      font_size = 16.0,
      color_scheme = 'Earthsong',
      hide_tab_bar_if_only_one_tab = true,
      window_decorations = "RESIZE",
    }
    '';
  };

  programs.broot = {
    enable = true;
  };

  programs.yazi = {
    enable = true;
  };

  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = "23.05";
}

# vim: fdm=marker:fdl=0:et:sw=2
