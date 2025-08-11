{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # shared config
    ../shared/configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Load AMD directly at boot
  boot.initrd.kernelModules = [ "amdgpu" ];

  networking.hostName = "wyvern"; # Define your hostname.
  # Use NVIDIA driver (required for PRIME offload)
  services.xserver.videoDrivers = [ "nvidia" ];

  # Enable the KDE Plasma Desktop Environment.
  #services.displayManager.sddm = {
  #  enable = true;
  #  wayland.enable = true;
  #};
  services.desktopManager.plasma6.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
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

  hardware.bluetooth.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [ ];

  # workaround for https://github.com/NixOS/nixpkgs/issues/414135
  security.lsm = lib.mkForce [ ];

  # sunshine server
  services.sunshine = {
    enable = true;
    autoStart = false;
    capSysAdmin = true;
    openFirewall = true;
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

  # List services that you want to enable:

  # Enable asus utils
  services.asusd.enable = true;
  #services.supergfxd.enable = true;

  # Enable upower for battery monitoring.
  services.upower.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}

# vim: fdm=marker:fdl=0:et:sw=2
