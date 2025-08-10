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
  ];

  programs.git = {
    enable     = true;
    userName   = "Oliver McInnes";
    userEmail  = "olivermcinnes@example.com";
  };
}
