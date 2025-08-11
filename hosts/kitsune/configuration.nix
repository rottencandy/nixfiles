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

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "kitsune"; # Define your hostname.

  # Enable the GNOME Desktop Environment.
  #services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # disable power button
  # see all options in /etc/systemd/logind.conf
  services.logind.extraConfig = ''
    HandlePowerKey=ignore
  '';

  # hardware accel
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  # Allow amdvlk if applications prefer
  hardware.graphics.extraPackages = with pkgs; [
    amdvlk
  ];
  # For 32 bit applications
  hardware.graphics.extraPackages32 = with pkgs; [
    driversi686Linux.amdvlk
  ];
  # linux amdgpu controller
  systemd.packages = with pkgs; [ lact ];
  systemd.services.lactd.wantedBy = [ "multi-user.target" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # linux amdgpu controller
    lact
  ];

  # sunshine server
  services.sunshine = {
    enable = true;
    autoStart = false;
    capSysAdmin = true;
    openFirewall = true;
  };

  # TLP
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      # mimic power-profiles-daemon
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "balanced";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_performance";
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      # allow phone charging through usb
      USB_EXCLUDE_PHONE = 1;

      STOP_CHARGE_THRESH_BAT0 = 1; # stop charging at 80
    };
  };
  # this conflicts with tlp
  services.power-profiles-daemon.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}

# vim: fdm=marker:fdl=0:et:sw=2
