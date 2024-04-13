{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      format = lib.concatStrings [
        "$directory"
        "$git_branch"
        "$cmd_duration"
        "$battery"
        "$sudo"
        "$container"
        "$nix_shell"
        "$line_break"
        "$character"
      ];
      add_newline = false;
      # wait time(in md) for starship to check files under current dir
      scan_timeout = 10;
      character = {
        success_symbol = "[󰘧](bold green) ";
        error_symbol = "[󰘧](bold red) ";
      };
      battery.display = [
        {
          threshold = 30;
          style = "bold yellow";
        }
        {
          threshold = 20;
          style = "bold red";
        }
      ];

      directory = {
        truncation_length = 4;
        truncation_symbol = ".../";
        #fish_style_pwd_dir_length = "1";
      };

      git_branch = {
        #symbol = '__ '
        #truncation_length = 7
        #truncation_symbol = '...'
      };

      cmd_duration.format = " \\[[$duration]($style)\\] ";

      nix_shell = {
        #heuristic = true;
      };
    };
  };
}

# vim: fdm=marker:fdl=0:et:sw=2
