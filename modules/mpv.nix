{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      uosc
      thumbfast
    ];
    config = {
      ytdl-format = "bestvideo+bestaudio";
    };
  };
}

# vim: fdm=marker:fdl=0:et:sw=2
