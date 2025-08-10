{ config, pkgs, ... }:

{
  networking.hostName = "vivy";
  services.openssh.enable = true;

  users.users.net = {
    isNormalUser = true;
    extraGroups  = [ "wheel" ];
  };

  system.stateVersion = "25.05";
}