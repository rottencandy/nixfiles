{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim
    neovide
    #macvim
  ];

  home.file = {
    ".config/nvim/init.vim".source = ./init.vim;
    ".vim" = {
      source = ./vim;
      recursive = true;
    };
  };
}

# vim: fdm=marker:fdl=0:et:sw=2
