{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [ tmux ];

  home.file = {
    ".tmux.conf".source = ./tmux.conf;
  };
}

# vim: fdm=marker:fdl=0:et:sw=2
