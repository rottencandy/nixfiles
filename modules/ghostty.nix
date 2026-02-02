{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    ghostty
  ];

  home.file = {
    ".config/ghostty/config".text = ''
      theme = Adventure
      title = " "
      window-decoration = false
      font-size = 10
      background = "#000000"
      window-inherit-working-directory = false
    '';
  };
}

# vim: fdm=marker:fdl=0:et:sw=2
