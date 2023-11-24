{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    todo-txt-cli
  ];

  home.file = {
    ".todo.cfg".source = ../../home/todo.cfg;
  };
}

# vim: fdm=marker:fdl=0:et:sw=2
