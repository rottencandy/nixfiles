{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require 'wezterm'

      return {
        font = wezterm.font 'FiraCode Nerd Font Mono',
        font_size = 10.0,
        color_scheme = 'Earthsong',
        hide_tab_bar_if_only_one_tab = true,
        hide_mouse_cursor_when_typing = false,
        window_decorations = "RESIZE",

        -- temp workaround for https://github.com/wez/wezterm/issues/5990
        enable_wayland = true,
        front_end = 'WebGpu',
        webgpu_power_preference = 'HighPerformance',

      }
    '';
  };
}

# vim: fdm=marker:fdl=0:et:sw=2
