{ config, pkgs, ... }:

let
  # bash script to let dbus know about important env variables and
  # propagate them to relevent services run at the end of sway config
  # see
  # https://github.com/emersion/xdg-desktop-portal-wlr/wiki/"It-doesn't-work"-Troubleshooting-Checklist
  # note: this is pretty much the same as  /etc/sway/config.d/nixos.conf but also restarts
  # some user services to make sure they have the correct environment variables
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };

  # currently, there is some friction between sway and gtk:
  # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
  # the suggested way to set gtk settings is with gsettings
  # for gsettings to work, we need to tell it where the schemas are
  # using the XDG_DATA_DIR environment variable
  # run at the end of sway config
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text =
      let
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gsettings-schemas/${schema.name}";
      in
      ''
        export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
        gnome_schema=org.gnome.desktop.interface
        gsettings set $gnome_schema gtk-theme 'Dracula'
      '';
  };
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    #../../modules/syncthing.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Load AMD directly at boot
  boot.initrd.kernelModules = [ "amdgpu" ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Enable the X11 windowing system
  services.xserver.enable = true;
  # but don't run a display manager by default
  services.xserver.autorun = false;
  # Use NVIDIA driver (required for PRIME offload)
  services.xserver.videoDrivers = [ "nvidia" ];

  # Enable the KDE Plasma Desktop Environment.
  #services.displayManager.sddm = {
  #  enable = true;
  #  wayland.enable = true;
  #};
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.startx.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable opengl
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      # Allow programs to optionally choose amdvlk
      amdvlk
      # trying to fix `WLR_RENDERER=vulkan sway`
      vulkan-validation-layers
    ];
  };

  hardware.nvidia = {
    # Needed for most wayland compositors
    modesetting.enable = true;
    # Use proprietary module
    open = false;
    # Enable settings menu
    nvidiaSettings = true;
    # Use stable driver package
    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    #package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    #  version = "550.67";
    #  sha256_64bit = "sha256-mSAaCccc/w/QJh6w8Mva0oLrqB+cOSO1YMz1Se/32uI=";
    #  sha256_aarch64 = "sha256-+UuK0UniAsndN15VDb/xopjkdlc6ZGk5LIm/GNs5ivA=";
    #  openSha256 = "sha256-M/1qAQxTm61bznAtCoNQXICfThh3hLqfd0s1n1BFj2A=";
    #  settingsSha256 = "sha256-FUEwXpeUMH1DYH77/t76wF1UslkcW721x9BHasaRUaM=";
    #  persistencedSha256 = "sha256-ojHbmSAOYl3lOi2X6HOBlokTXhTCK6VNsH6+xfGQsyo=";
    #  ibtSupport = true;
    #};
    #package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    #  version = "550.76";
    #  sha256_64bit = "sha256-2/wAmBNiePhX74FsV7j21LnCaubxMC/kAYMmf8kQt1s=";
    #  sha256_aarch64 = "sha256-LhiyYCUTFwqzUITK6CKIqxOQp62wG1RuKOuP0fTKoVk=";
    #  openSha256 = "sha256-RWaUXIr/yCRmX4yIyUxvBxrKCLKRKSi4lQJAYvrd2Kg=";
    #  settingsSha256 = "sha256-Lv95+0ahvU1+X/twzWWVqQH4nqq491ALigH9TVBn+YY=";
    #  persistencedSha256 = "sha256-rbgI9kGdVzGlPNEvaoOq2zrAMx+H8D+XEBah2eqZzuI=";
    #};

    # Enable prime offloading
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      allowExternalGpu = true;
      nvidiaBusId = "PCI:1:0:0"; # lspci | grep VGA | grep NVIDIA
      amdgpuBusId = "PCI:5:0:0"; # lspci | grep VGA | grep AMD
    };
    powerManagement.finegrained = true;
  };

  # Enable qmk hardware support for a normal non-root user
  hardware.keyboard = {
    qmk.enable = true;
  };

  # Enable CUPS to print documents.
  #services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  hardware.bluetooth.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.saud = {
    isNormalUser = true;
    description = "saud";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "libvirtd"
      "adbusers"
      "dialout"
    ];
    #packages = with pkgs; [
    #  thunderbird
    #];
  };

  nixpkgs = {
    hostPlatform = "x86_64-linux";
    config = {
      allowUnfree = true;
    };
    overlays = [ ];
  };

  nix = {
    package = pkgs.nixVersions.stable;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "saud"
      ];
      substituters = [
        "https://cuda-maintainers.cachix.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # utils
    dbus-sway-environment
    configure-gtk
    xdg-utils

    # libs
    glib
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.iosevka
  ];

  security.polkit.enable = true;
  security.pam.services.swaylock = { };

  # xdg-desktop-portal works by exposing a series of D-Bus interfaces
  # known as portals under a well-known name
  # (org.freedesktop.portal.Desktop) and object path
  # (/org/freedesktop/portal/desktop).
  # The portal interfaces include APIs for file access, opening URIs,
  # printing and others.
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy (also needed for flatpak)
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    # xdg-desktop-portal 1.17 reworked how portal implementations are loaded
    # we need to specify which portal backend t o use for the requested interface
    # this option simply keeps behaviour the same as < 1.17, i.e.. use the first
    # portal implementation found in lexicographical order
    config.common.default = "*";
  };

  # key daemon
  # https://github.com/rvaiya/keyd/blob/master/keyd.service
  systemd.services.keyd = {
    enable = false;
    requires = [ "local-fs.target" ];
    after = [ "local-fs.target" ];
    wantedBy = [ "sysinit.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.keyd}/bin/keyd";
    };
  };
  environment.etc."keyd/default.conf".text = ''
    [ids]
    *

    [main]
    # Maps capslock to escape when pressed and control when held.
    capslock = overload(control, esc)

    # Remaps the escape key to capslock
    esc = capslock

    # Remaps print to second meta(super) key
    compose = rightmeta
    sysrq = rightmeta
  '';

  # steam client
  #programs.steam = {
  #  enable = true;
  #  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  #  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  #};

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.firefox = {
    enable = true;
    nativeMessagingHosts.packages = [ pkgs.tridactyl-native ];
  };

  # List services that you want to enable:

  # Enable flatpak
  #services.flatpak.enable = true;

  # Enable asus utils
  services.asusd.enable = true;
  #services.supergfxd.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable upower for battery monitoring.
  services.upower.enable = true;

  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
    allowedTCPPortRanges = [
      # KDE Connect
      {
        from = 1714;
        to = 1764;
      }
      # Localsend
      {
        from = 53317;
        to = 53317;
      }
    ];
    allowedUDPPortRanges = [
      # KDE Connect
      {
        from = 1714;
        to = 1764;
      }
      # Localsend
      {
        from = 53317;
        to = 53317;
      }
    ];
  };

  # android tools
  programs.adb.enable = true;

  # Enable virtualisation
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Enable common container config files in /etc/containers
  virtualisation.containers.enable = true;
  virtualisation.podman = {
    enable = true;
    # Create a `docker` alias for podman, to use it as a drop-in replacement
    #dockerCompat = true;

    # Required for containers under podman-compose to be able to talk to each other.
    defaultNetwork.settings.dns_enabled = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}

# vim: fdm=marker:fdl=0:et:sw=2
