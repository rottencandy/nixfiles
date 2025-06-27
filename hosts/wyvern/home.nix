{ ghostty, paisa }:

{
  pkgs,
  ...
}:

let
  # Script to run processes using discrete Nvidia GPU
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';

  # script to interactively select and activate a dev shell
  devshell = pkgs.writeShellScriptBin "shl" ''
    SEL=$(nix flake show --json ~/nix | jq '.devShells."x86_64-linux" | keys | .[]' -r | fzf)
    if [ -z "$SEL" ]; then
      exit
    fi;
    nix develop ~/nix#$SEL
  '';

in
# nix-alien to run non-NixOS binaries in a compatible FHS environment with
# all needed shared dependencies
#nix-alien-pkgs = import (
#  builtins.fetchTarball "https://github.com/thiagokokada/nix-alien/tarball/master"
#) { };
{
  imports = [
    ../../modules/vim
    ../../modules/bash
    ../../modules/tmux
    ../../modules/todo
    ../../modules/sway
    ../../modules/halloy
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

  # Overwrite steam.desktop shortcut so that is uses PRIME
  # offloading for Steam and all its games
  #home.activation.steam = lib.hm.dag.entryAfter ["writeBoundary"] ''
  #  $DRY_RUN_CMD sed 's/^Exec=/&nvidia-offload /' \
  #    ${pkgs.steam}/share/applications/steam.desktop \
  #    > ~/.local/share/applications/steam.desktop
  #  $DRY_RUN_CMD chmod +x ~/.local/share/applications/steam.desktop
  #'';

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
    qmk
    wget
    curl
    foot
    delta
    emacs
    helix
    jless
    ugrep
    ripgrep
    gnumake
    pandoc
    neovide
    moreutils
    difftastic
    shellcheck
    devshell
    lua-language-server
    stylua
    webkitgtk_6_0
    repomix
    aider-chat
    claude-code
    zed-editor-fhs

    # langs
    janet
    clang
    mold
    #gcc
    luajit

    # terminal
    ueberzugpp
    #alacritty
    ghostty.packages.x86_64-linux.default
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
    asusctl
    nvidia-offload
    nvtopPackages.full
    mangohud
    redshift
    blueman
    usbutils
    smartmontools
    nvme-cli

    # web
    yt-dlp
    gallery-dl
    streamlink
    ungoogled-chromium
    google-chrome
    qbittorrent
    freetube

    # networkinag
    wireguard-tools
    #openvpn
    mosh
    localsend
    hexchat

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
    #vlc
    mpv
    feh
    gimp
    losslesscut-bin

    # accounting
    ledger
    visidata
    #paisa.packages.x86_64-linux.default

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
    kanshi
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
    dolphin-emu
    pcsx2
    #rpcs3
    mame
    cemu
    ppsspp
    godot_4
    unciv
    nethack
    ruffle
    #unnethack

    # Non-free
    anydesk
    #telegram-desktop
  ];

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

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.
}

# vim: fdm=marker:fdl=0:et:sw=2
