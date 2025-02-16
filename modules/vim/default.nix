{
  config,
  lib,
  pkgs,
  ...
}:

let
  fzfPluginPath = "${pkgs.fzf.outPath}/share/nvim/site";
in
{
  home.packages = with pkgs; [
    vim
    gnvim
    neovim
    neovide
    #macvim
  ];

  home.file = {
    ".vim/common.vim" = {
      source = ./vim/common.vim;
    };
    ".config/nvim/init.lua".text =
      builtins.replaceStrings [ "@@FZF_PLUGIN_PATH@@" ] [ fzfPluginPath ]
        (builtins.readFile ./init.lua);
    ".vim/vimrc".text = 
      builtins.replaceStrings [ "@@FZF_PLUGIN_PATH@@" ] [ fzfPluginPath ]
        (builtins.readFile ./vim/vimrc);
    ".config/snippets" = {
      source = ./snippets;
      recursive = true;
    };
  };
}

# vim: fdm=marker:fdl=0:et:sw=2
