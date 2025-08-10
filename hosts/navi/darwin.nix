{ lib, config, pkgs, ... }:

{
  system.primaryUser = "olivermcinnes";

  imports = [
    ./spotlight-hack.nix
  ];

  networking.hostName = "navi";

  users.users.olivermcinnes = {
    home  = "/Users/olivermcinnes";
    shell = pkgs.zsh;
  };

  system.stateVersion = 6;
}