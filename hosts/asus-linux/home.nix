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

  # Grab a password from the password store into the clipboard using fzf
  pass-get = pkgs.writeShellScriptBin "getp" ''
    PASS_DIR=~/.password-store
    selection=$(cd $PASS_DIR && fd --type f | fzf)
    if [ -z $selection ]; then return; fi
    pass -c "''${selection//.gpg/}"
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
    ../../modules/git.nix
    ../../modules/fzf.nix
    ../../modules/hyprland
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
    gparted
    pandoc
    delta
    emacs
    rio
    helix
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
    wget
    curl
    moreutils
    ripgrep
    pass
    #gcc
    clang
    mold
    pinentry
    #nix-alien-pkgs.nix-alien
    bubblewrap
    gnumake

    # wine stuff
    dwarfs
    fuse-overlayfs
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-vaapi
    #wineWowPackages.waylandFull
    wine-staging
    winetricks

    # shell functions
    pass-get

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
    pcsx2
    firefox
    godot_4
    zathura
    freetube
    alacritty

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
    ".config/sway/config".source = ../../home/sway.config;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

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
