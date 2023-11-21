NixOS Configuration
===

Cross-platform nix configuration for Linux and MacOS.

## Installation

- [Install nix](https://nixos.org/download) (if not already on NixOS)

- [MacOS only] Install [nix-darwin](https://github.com/LnL7/nix-darwin)

- Initial build

    - Using [flakes](https://nixos.wiki/wiki/Flakes) requires git, use a temporary shell if not available: `nix-shell -p git`

    - Use experimental flags for first build, since flakes are not available by default

    Linux:
    ```sh
    sudo nixos-rebuild switch --flake . --experimental-features 'nix-command flakes'
    ```

    MacOS:
    ```sh
    darwin-rebuild switch --flake . --experimental-features 'nix-command flakes'
    ```

Subsequent builds can be done with:
```
make
```

See [Makefile](./Makefile) for more commands.
