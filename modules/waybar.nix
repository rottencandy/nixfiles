{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "bottom";
        height = 24;
        spacing = 2;

        modules-left = [ "sway/workspaces" ];
        modules-right = [
          "idle_inhibitor"
          "memory"
          "cpu"
          "disk"
          "temperature"
          "network"
          "battery"
          "clock"
          "tray"
        ];

        tray = {
          # icon-size = 21;
          spacing = 10;
        };

        clock = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format = "{:%I:%M}";
        };
      };
    };
  };
}

# vim: fdm=marker:fdl=0:et:sw=2
