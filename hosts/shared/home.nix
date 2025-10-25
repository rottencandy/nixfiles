{
  pkgs,
  ...
}:

let
  # script to interactively select and activate a dev shell
  devshell = pkgs.writeShellScriptBin "shl" ''
    SEL=$(nix flake show --json ~/nix | jq '.devShells."x86_64-linux" | keys | .[]' -r | fzf)
    if [ -z "$SEL" ]; then
      exit
    fi;
    nix develop ~/nix#$SEL
  '';

  # nix-alien to run non-NixOS binaries in a compatible FHS environment with
  # all needed shared dependencies
  #nix-alien-pkgs = import (
  #  builtins.fetchTarball "https://github.com/thiagokokada/nix-alien/tarball/master"
  #) { };
in
{
  imports = [
    ../../modules/vim
    ../../modules/bash
    ../../modules/tmux
    ../../modules/todo
    #../../modules/sway
    ../../modules/niri
    ../../modules/keepassxc
    ../../modules/git.nix
    ../../modules/fzf.nix
    ../../modules/rio.nix
    ../../modules/pass.nix
    ../../modules/broot.nix
    ../../modules/ghostty.nix
    #../../modules/wezterm.nix
    ../../modules/starship.nix
    #../../modules/vscodium.nix
    ../../modules/tridactyl.nix
  ];
  home.username = "saud";
  home.homeDirectory = "/home/saud";

  home.packages = with pkgs; [
    # nix utils
    nixd
    cachix
    steam-run
    appimage-run
    nixfmt-rfc-style
    #nix-alien-pkgs.nix-alien

    # dev
    xh
    jq
    wget
    curl
    foot
    delta
    emacs
    helix
    jless
    ugrep
    gnumake
    pandoc
    neovide
    moreutils
    difftastic
    shellcheck
    devshell
    lua-language-server
    stylua
    repomix
    aider-chat
    claude-code
    opencode
    codex
    zed-editor-fhs
    psmisc
    google-cloud-sdk

    # langs
    janet
    clang
    mold
    #gcc
    luajit

    # terminal
    ueberzugpp
    #alacritty
    fbterm
    contour

    # filesystem
    fd
    bat
    nnn
    lsd
    zip
    tio
    yazi
    file
    unrar
    unzip
    p7zip
    zathura
    caligula
    bk

    # crypto
    pinentry
    cryptsetup

    # containerization
    distrobox
    bubblewrap
    gnome-boxes

    # hardware
    macchina
    bottom
    htop
    btop
    mangohud
    blueman
    usbutils
    smartmontools
    nvme-cli

    # web
    yt-dlp
    gallery-dl
    streamlink
    qbittorrent
    freetube

    # networkinag
    wireguard-tools
    #openvpn
    mosh
    localsend
    hexchat
    tigervnc

    # multimedia
    jamesdsp
    nuclear
    musikcube
    #vcv-rack
    pwvucontrol
    sox
    coppwr
    imagemagick
    ffmpeg
    flac
    vlc
    mpv
    feh
    gimp
    losslesscut-bin

    # accounting
    ledger
    visidata

    # window manager
    notify-desktop
    wdisplays
    wf-recorder
    wl-clipboard
    wev
    tofi
    dunst
    grim
    slurp
    #kanshi
    brightnessctl

    # wine
    dwarfs
    bottles
    protonup-qt
    fuse-overlayfs
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-vaapi
    wine-staging
    winetricks
    #protontricks
    gamescope

    # games
    lutris
    umu-launcher
    #heroic
    #dolphin-emu
    #pcsx2
    #rpcs3
    mame
    #cemu
    #ppsspp
    godot_4
    unciv
    nethack
    ruffle
    #unnethack
    moonlight-qt
    #parsec-bin
  ];

  programs.ripgrep = {
    enable = true;
    arguments = [
      "--smart-case"
      #"--hidden"
      "--glob"
      "!.git"
    ];
  };

}

# vim: fdm=marker:fdl=0:et:sw=2
