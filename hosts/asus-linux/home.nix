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
    ../../modules/wezterm.nix
    ../../modules/starship.nix
    ../../modules/vscodium.nix
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
    # tools
    ffmpeg
    flac
    cryptsetup
    pandoc
    delta
    difftastic
    emacs
    helix
    macchina
    xh
    fd
    bat
    nnn
    mosh
    yazi
    bottom
    htop
    lsd
    jq
    jless
    yt-dlp
    gallery-dl
    wget
    curl
    moreutils
    ripgrep
    pinentry
    #nix-alien-pkgs.nix-alien
    bubblewrap
    gnumake
    streamlink
    ledger
    qmk
    shellcheck
    distrobox
    jamesdsp
    wireguard-tools
    visidata
    notify-desktop

    # wine stuff
    dwarfs
    fuse-overlayfs
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-vaapi
    wine-staging
    winetricks

    # applications
    qbittorrent
    #vlc
    mpv
    feh
    gimp
    lutris
    #heroic
    hexchat
    neovide
    bottles
    dolphin-emu
    pcsx2
    mame
    cemu
    ppsspp
    godot_4
    zathura
    freetube
    alacritty
    ghostty.packages.x86_64-linux.default
    paisa.packages.x86_64-linux.default
    ungoogled-chromium
    google-chrome
    gnome-boxes
    fbterm
    bk
    surge
    nuclear
    musikcube

    # games
    unciv
    nethack
    unnethack

    # utils
    asusctl
    nvidia-offload
    devshell
    steam-run
    appimage-run
    nvtopPackages.full
    protonup-qt
    gamescope
    mangohud
    redshift
    #openvpn
    brightnessctl
    file
    localsend
    unrar
    zip
    unzip
    p7zip
    usbutils
    wev
    sox
    blueman
    ueberzugpp
    pwvucontrol
    coppwr

    # nix utils
    cachix
    nixd

    # languages
    janet
    clang
    mold
    #gcc

    # WM
    wdisplays
    wf-recorder
    wl-clipboard
    tofi
    dunst
    grim
    slurp
    kanshi

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
