{
  config,
  lib,
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
    pushd ~/nix
    trap popd EXIT
    SEL=$(nix flake show --json | jq '.devShells."x86_64-linux" | keys | .[]' -r | fzf)
    if [ -z "$SEL" ]; then
      exit
    fi;
    nix develop ".#$SEL"
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
    ../../modules/dev-shell
    ../../modules/git.nix
    ../../modules/fzf.nix
    ../../modules/rio.nix
    ../../modules/pass.nix
    ../../modules/sway
    ../../modules/halloy
    ../../modules/hyprland
    ../../modules/wezterm.nix
    ../../modules/starship.nix
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

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # tools
    ffmpeg
    flac
    gparted
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
    yazi
    broot
    bottom
    htop
    lsd
    jq
    jless
    yt-dlp
    wget
    curl
    moreutils
    ripgrep
    pinentry
    #nix-alien-pkgs.nix-alien
    bubblewrap
    gnumake
    streamlink
    qmk
    shellcheck
    distrobox
    jamesdsp
    wireguard-tools
    visidata

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
    vlc
    mpv
    feh
    gimp
    lutris
    #heroic
    hexchat
    neovide
    bottles
    #pcsx2
    godot_4
    zathura
    freetube
    alacritty
    ungoogled-chromium
    gnome.gnome-boxes
    fbterm
    bk

    # games
    unciv
    nethack
    unnethack

    # utils
    asusctl
    nvidia-offload
    devshell
    steam-run
    nvtopPackages.full
    protonup-qt
    gamescope
    mangohud
    redshift
    openvpn
    brightnessctl
    unrar
    unzip
    usbutils
    wev
    sox
    blueman
    ueberzugpp

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
    mako
    grim
    slurp
    kanshi

    # Non-free
    anydesk
    #telegram-desktop

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

  # kanshi, ripgrep do not exist on stable branch of home-manager yet :/

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

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

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
