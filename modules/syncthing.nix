{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.syncthing = {
    enable = true;
    user = "saud";
    dataDir = "/home/saud/synced";
    configDir = "/home/saud/synced/.config/syncthing";
  };
}

# vim: fdm=marker:fdl=0:et:sw=2
