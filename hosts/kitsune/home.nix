{
  pkgs,
  ...
}:

{
  imports = [
    ../shared/home.nix
  ];

  home.packages = with pkgs; [
    # cpu power management
    ryzenadj
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
