{
  description = "frentend development environment";

  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1"; # unstable Nixpkgs

  outputs =
    { self, ... }@inputs:

    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forEachSupportedSystem =
        f:
        inputs.nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            pkgs = import inputs.nixpkgs {
              inherit system;
              overlays = [ inputs.self.overlays.default ];
            };
          }
        );
    in
    {
      overlays.default = final: prev: rec {
        nodejs = prev.nodejs;
        yarn = (prev.yarn.override { inherit nodejs; });
      };

      devShells = forEachSupportedSystem (
        { pkgs }:
        let
          # Adding libuuid to some node binaries are required by the
          # "node-canvas" package
          wrapWithMissingLibraries =
            binaryFile:
            pkgs.writeShellScriptBin (baseNameOf binaryFile) ''
              LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [ pkgs.libuuid ]}";
              export LD_LIBRARY_PATH;
              exec ${binaryFile} "$@";
            '';
          node = (wrapWithMissingLibraries (pkgs.lib.getExe pkgs.nodejs_24));
        in
        {
          default = pkgs.mkShellNoCC {
            packages = with pkgs; [
              python3
              pkg-config
              pixman
              cairo
              pango
              node2nix
              nodejs
              node
              yarn
              bun

              vscode-langservers-extracted
              nodePackages.typescript
              nodePackages.typescript-language-server
              nodePackages.svelte-language-server
            ];
          };
        }
      );
    };
}
