{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    vim
    neovim
    neovide
    #macvim
  ];

  home.file = {
    ".config/nvim/init.lua".source = ./init.lua;
    ".vim" = {
      source = ./vim;
      recursive = true;
    };
    ".config/snippets" = {
      source = ./snippets;
      recursive = true;
    };
  };
}

# vim: fdm=marker:fdl=0:et:sw=2
