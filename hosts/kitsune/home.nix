{ paisa, cloudypad, beads }:

{
  pkgs,
  ...
}:

{
  imports = [
    ../shared/home.nix
    ../../modules/halloy
  ];

  home.packages = with pkgs; [
    # web
    ungoogled-chromium
    google-chrome

    # cpu power management
    ryzenadj

    # other
    #paisa.packages.x86_64-linux.default
    #cloudypad.packages.x86_64-linux.default
    beads.packages.x86_64-linux.default

    # Non-free
    anydesk
    #telegram-desktop
  ];

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
