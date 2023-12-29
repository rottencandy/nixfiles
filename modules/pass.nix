{ config, lib, pkgs, ... }:

let

  # Grab a password from the password store into the clipboard using fzf
  pass-get = pkgs.writeShellScriptBin "getp" ''
    PASS_DIR=~/.password-store
    selection=$(cd $PASS_DIR && fd --type f | fzf)
    if [ -z $selection ]; then exit; fi
    pass -c "''${selection//.gpg/}"
  '';

in
{
  home.packages = with pkgs; [
    pass
    pass-get
  ];
}

# vim: fdm=marker:fdl=0:et:sw=2
