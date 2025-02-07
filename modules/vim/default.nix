{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    vim
    gnvim
    neovim
    neovide
    #macvim
  ];

  home.file = {
    ".config/nvim/init.lua".text =
      builtins.replaceStrings [ "@@FZF_PLUGIN_PATH@@" ] [ "${pkgs.fzf.outPath}/share/nvim/site" ]
        (builtins.readFile ./init.lua);
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
