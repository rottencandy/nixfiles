{ config, pkgs, lib, ... }:

{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        # "position": "bottom"; # Waybar position (top|bottom|left|right)
        # "width": 1280;
        height = 30;
        spacing = 4;

        modules-left = [ "hyprland/workspaces" ];
        #modules-center = [ "hyprland/window" ];
        modules-right = [ "idle_inhibitor" "network" "cpu" "memory" "temperature" "battery" "clock" "tray" ];

        "hyprland/workspaces" = {
          disable-scroll = true;
        };

        keyboard-state = {
          numlock = true;
          capslock = true;
          format = "{name} {icon}";
          format-icons = {
            locked = "";
            unlocked = "";
          };
        };

        cpu = {
          format = " {usage}%";
          tooltip = false;
        };

        memory = {
          format = " {used:0.1f}GB";
          tooltip-format = "available {avail:0.1f}GB";
        };

        temperature = {
          # "thermal-zone": 2,
          # "hwmon-path": "/sys/class/hwmon/hwmon2/temp1_input",
          critical-threshold = 80;
          # "format-critical": "{temperatureC}°C {icon}",
          format = "{temperatureC}°C {icon}";
          format-icons = ["" "" ""];
        };

        idle_inhibitor = {
            format = "{icon}";
            format-icons = {
              activated = "";
              deactivated = "";
            };
        };

        tray = {
          # "icon-size": 21;
          spacing = 10;
        };

        clock = {
          # "timezone": "America/New_York";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format = "{:%I:%M}";
          format-alt = "{:%h %d}";
        };

        battery = {
          states = {
            # "good" = 95;
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% 󱎗";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          # "format-good" = ""; // An empty format will hide the module
          # "format-full" = "";
          format-icons = ["" "" "" "" ""];
        };
        #"battery#bat2" = {
        #    bat = "BAT2";
        #};

        network = {
            # "interface": "wlp2*", // (Optional) To force the use of this interface
            format-wifi = "";
            format-ethernet = "(E) 󰈀";
            tooltip-format = "{essid}, {ifname} via {gwaddr}  ({signalStrength}%)";
            format-linked = "(No IP) 󰩟";
            format-disconnected = "󰖪";
            on-click = "gnome-control-center wifi";
        };
      };
    };
    style = builtins.readFile ./style.css;
  };

}

# vim: fdm=marker:fdl=0:et:sw=2
