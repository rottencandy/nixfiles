{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    skhd
  ];

  home.file = {
    ".config/skhd/skhdrc".text = ''
      cmd - return : wezterm
      cmd + shift - r : yabai -restart-service

      cmd + ctrl - h : yabai -m window --focus west
      cmd + ctrl - j : yabai -m window --focus south
      cmd + ctrl - k : yabai -m window --focus north
      cmd + ctrl - l : yabai -m window --focus east

      cmd + shift - h : yabai -m window --warp west
      cmd + shift - j : yabai -m window --warp south
      cmd + shift - k : yabai -m window --warp north
      cmd + shift - l : yabai -m window --warp east

      # requires scripting addition so
      # insead managed through system shortcuts
      #cmd - 1 : yabai -m space --focus 1
      #cmd - 2 : yabai -m space --focus 2
      #cmd - 3 : yabai -m space --focus 3
      #cmd - 4 : yabai -m space --focus 4
      #cmd - 5 : yabai -m space --focus 5

      # monitor focus, requires display number
      cmd + alt - l : yabai -m display --focus 1
      cmd + alt - h : yabai -m display --focus 2

      cmd + shift - 1 : yabai -m window --space 1; # yabai -m space --focus 1
      cmd + shift - 2 : yabai -m window --space 2; # yabai -m space --focus 2
      cmd + shift - 3 : yabai -m window --space 3; # yabai -m space --focus 3
      cmd + shift - 4 : yabai -m window --space 4; # yabai -m space --focus 4
      cmd + shift - 5 : yabai -m window --space 5; # yabai -m space --focus 5

      cmd - f1 : m volume up
      cmd - f2 : m volume down
      cmd + ctrl - n : wezterm -e bash -c "cd ~/code/notes && nvim _temp.md"

      cmd - m : bash -c ~/.scripts/passmenu
      cmd - f : yabai -m window --toggle zoom-fullscreen
      cmd - e : yabai -m window --toggle split
      cmd + shift - space : yabai -m window --toggle float --grid 4:4:1:1:2:2
    '';
    ".config/yabai/yabairc" = {
      text = ''
        #!/usr/bin/env sh

        yabai -m config layout bsp
        yabai -m config top_padding 16
        yabai -m config bottom_padding 16
        yabai -m config left_padding 16
        yabai -m config right_padding 16
        yabai -m config window_gap 8
        yabai -m config focus_follows_mouse autofocus
        yabai -m config mouse_follows_focus on
        yabai -m config mouse_modifier cmd
        yabai -m config external_bar all:32:0

        # float some applications by default
        yabai -m rule --add app="^(System Settings|Managed Software Centre|choose|Viscosity|Preview|mpv)$" manage=off
        # show digital colour meter topmost and on all spaces
        yabai -m rule --add app="^Digital Colour Meter$" sticky=on

        # janky borders
        borders active_color=0xffe1e3e4 inactive_color=0xff494d64 width=5.0 2>/dev/null 1>&2 &
      '';
      executable = true;
    };
  };
}

# vim: fdm=marker:fdl=0:et:sw=2
