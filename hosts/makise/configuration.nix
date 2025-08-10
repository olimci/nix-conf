{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "makise";

  # Graphical environment
  services.xserver.enable = true;
  services.xserver.windowManager.i3.enable = true;

  users.users.net = {
    isNormalUser = true;
    extraGroups  = [ "wheel" "networkmanager" ];
  };

  system.stateVersion = "25.05";
}