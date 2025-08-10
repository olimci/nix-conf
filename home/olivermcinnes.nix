{ lib, pkgs, ... }:

{
  home.stateVersion = "25.05";

  imports = [
    ./modules/zsh.nix
    ./modules/neovim.nix
    ./modules/kitty.nix
    ./modules/go.nix
  ];

  home.packages = with pkgs; [
    go gh fd ripgrep jq tree magic-wormhole
    thefuck git wget curl gnupg direnv python3
    nodejs unzip python312 uv

    anki-bin
    brave
    discord
    jetbrains.goland
    signal-desktop
    spotify
    tailscale
  ];
}
