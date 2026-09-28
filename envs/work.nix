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
          version = "1.4.0";
          bunUrl = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64.zip";
          bunReleaseHash = "sha256-LQP7X7g6yLVnrKCigbLOGhoZ1Ij1bClo2Iw/Jekv5FI=";
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

          meat = pkgs.buildGoModule {
            pname = "meat";
            version = "unstable-2026-08-03";

            src = pkgs.fetchFromGitHub {
              owner = "boldsoftware";
              repo = "meat";
              rev = "f39f41dfe7b5b37a12b35fdfbaecc7e779855bd3";
              hash = "sha256-fj04sdMiwPxh4F+kBpF5c+YYeKnKCDD9dsIgwAGPoK4=";
            };

            # No external Go module dependencies.
            vendorHash = null;

            subPackages = [ "cmd/meat" ];

            meta = with pkgs.lib; {
              description = "Abridge a code diff into a reading diff";
              homepage = "https://github.com/boldsoftware/meat";
              license = licenses.asl20;
              mainProgram = "meat";
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
              #self.packages.${system}.meat

              vscode-langservers-extracted
              typescript
              typescript-language-server
              svelte-language-server

              grpcurl
              go_1_26
              gopls
              gcc

              just
              buf
              pkg-config

              python3

              (fenixPkgs.fromToolchainFile {
                file = ./ferrite/rust-toolchain.toml;
                sha256 = "sha256-0SsYbtpnHZd48wvujhCnGdLzZ3C7JAaecq+LsSERvj4=";
              })
              fenixPkgs.rust-analyzer
              wasm-bindgen-cli
            ];

            buildInputs = with pkgs; [
              pipewire.jack
              jack1
              alsa-lib
              alsa-lib.dev
              alsa-plugins
              dbus
              zlib
            ];

            # Set any environment variables for your dev shell
            env = { };

            LD_LIBRARY_PATH =
              with pkgs;
              lib.makeLibraryPath [
                pipewire
                pipewire.jack
                jack1
                alsa-lib
                alsa-lib.dev
                alsa-plugins
                openssl
                libuuid
                zlib
                dbus
              ];

            # Add any shell logic you want executed any time the environment is activated
            shellHook = "";
          };
        }
      );
    };
}
