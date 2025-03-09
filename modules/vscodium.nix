{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium.fhs;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      esbenp.prettier-vscode
    ];
  };
}

# vim: fdm=marker:fdl=0:et:sw=2
