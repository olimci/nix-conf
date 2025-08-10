# modules/tailscale.nix
{ lib, pkgs, config, ... }:
let
  cfg = config.my.tailscale;

  tailscaleUpFlags =
    (lib.optional cfg.useSSH "--ssh")
    ++ (lib.optional cfg.acceptRoutes "--accept-routes")
    ++ (lib.optional cfg.advertiseExitNode "--advertise-exit-node")
    ++ cfg.extraUpFlags;
in
{
  options.my.tailscale = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Tailscale (NixOS and nix-darwin).";
    };

    useSSH = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Tailscale SSH (--ssh).";
    };

    acceptRoutes = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Accept subnet routes/exit nodes (--accept-routes).";
    };

    advertiseExitNode = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Advertise this machine as an exit node (--advertise-exit-node).";
    };

    extraUpFlags = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Extra flags to pass to `tailscale up`.";
    };

    extraDaemonFlags = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Extra flags to pass to `tailscaled` (NixOS).";
    };

    authKeyFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to a file containing a Tailscale auth key (NixOS, first start).";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      environment.systemPackages = [ pkgs.tailscale ];
    }

    # nix-darwin
    (lib.mkIf pkgs.stdenv.isDarwin {
      services.tailscale = {
        enable = true;
        package = pkgs.tailscale;
        openFirewall = true;
        extraUpFlags = tailscaleUpFlags;
      };
    })

    # NixOS
    (lib.mkIf pkgs.stdenv.isLinux {
      services.tailscale = {
        enable = true;
        package = pkgs.tailscale;
        openFirewall = true;
        extraUpFlags = tailscaleUpFlags;
        extraDaemonFlags = cfg.extraDaemonFlags;
        authKeyFile = lib.mkIf (cfg.authKeyFile != null) cfg.authKeyFile;
        useRoutingFeatures =
          if cfg.advertiseExitNode then "server"
          else if cfg.acceptRoutes then "client"
          else "none";
      };
    })
  ]);
}
