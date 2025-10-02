{
  lib,
  pkgs,
  ...
}:

let
  lockScreen = "${pkgs.swaylock}/bin/swaylock -f -c 000000";
  tofiFontPath = "${pkgs.nerd-fonts.fira-code.outPath}/share/fonts/truetype/NerdFonts/FiraCode/FiraCodeNerdFont-Medium.ttf";
in
{
  imports = [ ../waybar.nix ];

  xdg.configFile."niri/config.kdl".text =
    builtins.replaceStrings [ "@@TOFI_FONT_PATH@@" ] [ tofiFontPath ]
      (builtins.readFile ./config.kdl);

  home.packages = with pkgs; [
    swaylock
    hypridle
    niri
    xwayland-satellite
    xdg-desktop-portal-gtk
    xdg-desktop-portal-gnome
  ];

  programs.niriswitcher = {
    enable = true;
    settings = {
      modifier = "Super";
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "niri msg action power-on-monitors";
        ignore_dbus_inhibit = false;
        lock_cmd = lockScreen;
      };

      listener = [
        {
          timeout = 120;
          on-timeout = lockScreen;
        }
        {
          timeout = 130;
          on-timeout = "niri msg action power-off-monitors";
          on-resume = "niri msg action power-on-monitors";
        }
      ];
    };
  };
}

# vim: fdm=marker:fdl=0:et:sw=2
