{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    defaultCommand = "fd --type f";
    defaultOptions = [
      "--multi"
      "--cycle"
      "--height 16"
      "--color=dark"
      "--layout=reverse"
      "--prompt=' '"
      "--bind=ctrl-k:toggle-preview"
    ];
  };
}

# vim: fdm=marker:fdl=0:et:sw=2
