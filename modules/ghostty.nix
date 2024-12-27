{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.file = {
    ".config/ghostty/config".text = ''
      theme = Adventure
      title = " "
      window-decoration = false
    '';
  };
}

# vim: fdm=marker:fdl=0:et:sw=2
