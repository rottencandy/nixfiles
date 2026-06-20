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
      packages = forEachSupportedSystem (
        { pkgs, ... }:
        let
          version = "1.3.14";
          bunUrl = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64.zip";
          bunReleaseHash = "sha256-lR7iruhV8IWVruxiJSJqKY0/6oOj3NZGXAnLzN9+hI8=";
        in
        {
          bun = pkgs.stdenv.mkDerivation {
            pname = "bun";
            inherit version;
            src = pkgs.fetchurl {
              url = bunUrl;
              sha256 = bunReleaseHash;
            };
            nativeBuildInputs = [
              pkgs.unzip
              pkgs.autoPatchelfHook
            ];
            buildInputs = with pkgs; [
              stdenv.cc.cc.lib
              openssl
              libuuid
            ];
            buildPhase = "true";
            installPhase = ''
              mkdir -p $out/bin
              unzip -j $src -d $out/bin
              chmod +x $out/bin/bun
            '';
            meta = with pkgs.lib; {
              description = "Bun runtime (wrapped upstream binary) v${version}";
              homepage = "https://bun.sh";
              license = licenses.mit;
            };
          };
        }
      );
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
              self.packages.${system}.bun

              vscode-langservers-extracted
              typescript
              typescript-language-server
              svelte-language-server

              grpcurl
              go_1_26
              gopls

              just
              buf
              pkg-config

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

            LD_LIBRARY_PATH =
              with pkgs;
              lib.makeLibraryPath [
                pipewire
                pipewire.jack
                alsa-lib
                alsa-lib.dev
                alsa-plugins
                openssl
                libuuid
              ];

            # Add any shell logic you want executed any time the environment is activated
            shellHook = "";
          };
        }
      );
    };
}
