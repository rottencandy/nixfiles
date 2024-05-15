{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    # Install the wrapper into the system
    (
      let
        packages = with pkgs; [
          go_1_22
          rustup
          buf
          just
          gopls

          jack2
          alsa-lib
          pkg-config
          openssl
          wasm-bindgen-cli

          deno
          nodejs_20
          nodePackages.yarn
          vscode-langservers-extracted
          nodePackages.typescript-language-server
        ];
      in
      # web development environment, primarily node and Go support
      pkgs.runCommand "devshl"
        {
          # Dependencies that should exist in the runtime environment
          buildInputs = packages;
          # Dependencies that should only exist in the build environment
          nativeBuildInputs = [ pkgs.makeWrapper ];
        }
        ''
          mkdir -p $out/bin/
          ln -s ${pkgs.bashInteractive}/bin/bash $out/bin/devshl
          wrapProgram $out/bin/devshl --prefix PATH : ${pkgs.lib.makeBinPath packages}
        ''
    )
  ];
}

# vim: fdm=marker:fdl=0:et:sw=2
