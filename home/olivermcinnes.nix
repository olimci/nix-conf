{ lib, pkgs, ... }:

{
  home.stateVersion = "25.05";

  imports = [
    ./modules/zsh.nix
    ./modules/neovim.nix
    ./modules/kitty.nix
    ./modules/go.nix
    ./modules/tailscale.nix
  ];

  my.tailscale = {
    enable = true;
    useSSH = true;
    acceptRoutes = true;
    advertiseExitNode = false;
  };

  home.packages = with pkgs; [
    go gh fd ripgrep jq tree magic-wormhole
    thefuck git wget curl gnupg direnv python3
    nodejs unzip python312 uv

    discord
    jetbrains.goland
    spotify
  ];
}
