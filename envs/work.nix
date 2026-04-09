{
  description = "A flake.";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1"; # unstable Nixpkgs
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      fenix,
      ...
    }@inputs:

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
            inherit system;
            pkgs = import inputs.nixpkgs { inherit system; };
          }
        );
    in
    {
      devShells = forEachSupportedSystem (
        { pkgs, system }:
        let
          fenixPkgs = fenix.packages.${system};
        in
        {
          default = pkgs.mkShellNoCC {
            # The Nix packages provided in the environment
            # Add any you need here
            packages = with pkgs; [
              nodejs
              bun

              vscode-langservers-extracted
              typescript
              typescript-language-server
              svelte-language-server

              grpcurl
              go_1_26
              gopls

              just
              buf

              (fenixPkgs.fromToolchainFile {
                file = ./ferrite/rust-toolchain.toml;
                sha256 = "sha256-tqagmXrHoZA9Zmu2Br6n3MzvXaLkuPzKPS3NIVdNQVQ=";
              })
              fenixPkgs.rust-analyzer
              wasm-bindgen-cli
            ];

            buildInputs = [ ];

            # Set any environment variables for your dev shell
            env = { };

            LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
              pkgs.jack2
              pkgs.alsa-lib
              pkgs.openssl
              pkgs.libz
            ];

            # Add any shell logic you want executed any time the environment is activated
            shellHook = "";
          };
        }
      );
    };
}
