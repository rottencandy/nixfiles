{ config, pkgs, ... }:

{
  imports = [ ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    #pkgs.vim
  ];

  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  system = {
    defaults = {
      dock = {
        autohide = true;
        mru-spaces = false;
        show-recents = false;
        showhidden = true;
        wvous-tl-corner = 1;
        wvous-tr-corner = 1;
        wvous-bl-corner = 1;
        wvous-br-corner = 1;
      };
      trackpad = {
        Clicking = true;
        Dragging = true;
      };
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        AppleInterfaceStyle = "Dark";
        InitialKeyRepeat = 14;
        KeyRepeat = 1;
        _HIHideMenuBar = true;
      };

      # required for yabai
      spaces.spans-displays = false;
    };

    keyboard = {
      enableKeyMapping = true;
      # do this in karabiner
      #remapCapsLockToEscape = true;
    };

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 4;
  };

  networking = {
    dns = [
      "1.1.1.1"
      "1.0.0.1"
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
    ];
    # required for dns config to work
    knownNetworkServices = [
      "Wi-Fi"
      "Ethernet Adaptor"
      "Thunderbolt Ethernet"
    ];
  };

  fonts = {
    fontDir.enable = true;
    fonts = [ (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; }) ];
  };

  users.users.msaud = {
    name = "msaud";
    home = "/Users/msaud";
    packages = with pkgs; [
      # macvim
    ];
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
    };
    taps = [
      "koekeishiya/formulae"
      "FelixKratz/formulae"
    ];
    brews = [
      "koekeishiya/formulae/yabai"
      "FelixKratz/formulae/borders"
      "openshift-cli"
      "choose-gui"
    ];
    casks = [
      "eloston-chromium"
      "podman-desktop"
      "obs"
      "blender"
      "godot"
      "crystalfetch"
      "UTM"
    ];
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # config managed by home-manager
  services.sketchybar = {
    enable = true;
  };
}

# vim: fdm=marker:fdl=0:et:sw=2
