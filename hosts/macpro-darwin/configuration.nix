{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    #pkgs.vim
  ];

  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  system = {
    defaults = {
      dock = {
        autohide = true;
        mru-spaces = false;
        wvous-tl-corner = 1;
        wvous-tr-corner = 1;
        wvous-bl-corner = 1;
        wvous-br-corner = 1;
      };
      trackpad = {
        Clicking = true;
        Dragging = true;
      };
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        AppleInterfaceStyle = "Dark";
        InitialKeyRepeat = 14;
        KeyRepeat = 1;
        _HIHideMenuBar = true;
      };

      # required for yabai
      spaces.spans-displays = false;
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 4;
  };

  networking = {
    dns = [
      "1.1.1.1"
      "1.0.0.1"
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
    ];
    # required for dns config to work
    knownNetworkServices = [
        "Wi-Fi"
        "Ethernet Adaptor"
        "Thunderbolt Ethernet"
    ];
  };

  fonts = {
    fontDir.enable = true;
    fonts = [
      (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];
  };

  users.users.msaud = {
    name = "msaud";
    home = "/Users/msaud";
    packages = with pkgs; [
      # macvim
    ];
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
    };
    taps = [
      "koekeishiya/formulae"
    ];
    brews = [
      "koekeishiya/formulae/yabai"
    ];
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  services.sketchybar = {
    enable = true;
    config = ''
PLUGIN_DIR="$CONFIG_DIR/plugins"

##### Bar Appearance #####
sketchybar --bar height=32        \
                 blur_radius=30   \
                 position=top     \
                 sticky=off       \
                 padding_left=10  \
                 padding_right=10 \
                 color=0x15ffffff

##### Changing Defaults #####
sketchybar --default icon.font="FiraCode Nerd Font Mono:Bold:17.0"  \
                     icon.color=0xffffffff                 \
                     label.font="FiraCode Nerd Font Mono:Bold:14.0" \
                     label.color=0xffffffff                \
                     padding_left=5                        \
                     padding_right=5                       \
                     label.padding_left=4                  \
                     label.padding_right=4                 \
                     icon.padding_left=4                   \
                     icon.padding_right=4

##### Adding Mission Control Space Indicators #####
SPACE_ICONS=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")

for i in "''${!SPACE_ICONS[@]}"
do
  sid=$(($i+1))
  sketchybar --add space space.$sid left                                 \
             --set space.$sid space=$sid                                 \
                              icon=''${SPACE_ICONS[i]}                     \
                              background.color=0x44ffffff                \
                              background.corner_radius=5                 \
                              background.height=20                       \
                              background.drawing=off                     \
                              label.drawing=off                          \
                              script="$PLUGIN_DIR/space.sh"              \
                              click_script="yabai -m space --focus $sid"
done

##### Adding Left Items #####
sketchybar --add item space_separator left                         \
           --set space_separator icon=                            \
                                 padding_left=10                   \
                                 padding_right=10                  \
                                 label.drawing=off                 \
                                                                   \
           --add item front_app left                               \
           --set front_app       script="$PLUGIN_DIR/front_app.sh" \
                                 icon.drawing=off                  \
           --subscribe front_app front_app_switched

##### Adding Right Items #####
# Some items refresh on a fixed cycle, e.g. the clock runs its script once
# every 10s. Other items respond to events they subscribe to, e.g. the
# volume.sh script is only executed once an actual change in system audio
# volume is registered. More info about the event system can be found here:
# https://felixkratz.github.io/SketchyBar/config/events

sketchybar --add item clock right                              \
           --set clock   update_freq=10                        \
                         icon=                                \
                         script="$PLUGIN_DIR/clock.sh"         \

           #                                                    \
           #--add item volume right                             \
           #--set volume  script="$PLUGIN_DIR/volume.sh"        \
           #--subscribe volume volume_change                    \
           #                                                    \
           #--add item battery right                            \
           #--set battery script="$PLUGIN_DIR/battery.sh"       \
           #              update_freq=120                       \
           #--subscribe battery system_woke power_source_change

##### Finalizing Setup #####
sketchybar --update
    '';
  };
}

# vim: fdm=marker:fdl=0:et:sw=2
