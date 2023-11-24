{ config, lib, pkgs, ... }:

{
  imports = [
    ../../modules/vim
    ../../modules/bash
    ../../modules/tmux
    ../../modules/todo
    ../../modules/yabai
    ../../modules/git.nix
    ../../modules/fzf.nix
    ../../modules/pass.nix
    ../../modules/sketchybar
    ../../modules/wezterm.nix
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
    ffmpeg
    imagemagick
    pandoc
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
  ];

  #programs.rio = {
  #  enable = true;
  #  settings = {
  #    theme = "gruvboxDark";
  #  };
  #};

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
