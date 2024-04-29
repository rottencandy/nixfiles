{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.i3status-rust = {
    enable = true;
    bars = {
      default = {
        blocks = [
          {
            alert = 10.0;
            block = "disk_space";
            info_type = "available";
            interval = 300;
            path = "/";
            warning = 20.0;
          }
          {
            block = "memory";
            format = " $icon $mem_used_percents ";
            format_alt = " $icon $swap_used_percents ";
          }
          {
            block = "cpu";
            interval = 30;
          }
          {
            block = "load";
            format = " $icon $1m ";
            interval = 30;
          }
          { block = "kdeconnect"; }
          {
            block = "temperature";
            format = " $icon $average ";
            interval = 30;
          }
          {
            block = "net";
            format = " $icon {$signal_strength $ssid $frequency|Wired connection} via $device ";
            interval = 30;
          }
          {
            block = "time";
            format = " $timestamp.datetime(f:'%a %d/%m %l:%M') ";
            interval = 60;
          }
        ];
      };
    };
  };
}

# vim: fdm=marker:fdl=0:et:sw=2
