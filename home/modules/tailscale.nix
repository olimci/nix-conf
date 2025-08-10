# modules/tailscale.nix
{ lib, pkgs, config, ... }:
let
  cfg = config.my.tailscale;
in
{
  options.my.tailscale = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Tailscale (both NixOS and nix-darwin).";
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
      description = "Extra flags to pass to `tailscaled`.";
    };

    authKeyFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to a file containing a Tailscale auth key (used on first start).";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.tailscale ];

    # Common flag construction for both platforms
    systemd.services = {}; # no-op on darwin, keeps eval happy
    assertions = [];

    # Build up the tailscale up flags from options
    _module.args.tailscaleUpFlags =
      (if cfg.useSSH then [ "--ssh" ] else [])
      ++ (if cfg.acceptRoutes then [ "--accept-routes" ] else [])
      ++ (if cfg.advertiseExitNode then [ "--advertise-exit-node" ] else [])
      ++ cfg.extraUpFlags;

    #### nix-darwin ####
    # maps to launchd service
    darwin = lib.mkIf pkgs.stdenv.isDarwin {
      services.tailscale = {
        enable = true;
        package = pkgs.tailscale;
        # Open the macOS Application Firewall automatically
        openFirewall = true;
        extraUpFlags = config.tailscaleUpFlags;
        extraDaemonFlags = cfg.extraDaemonFlags;
        # If provided, use an auth key file on first start
        authKeyFile = lib.mkIf (cfg.authKeyFile != null) cfg.authKeyFile;
      };
    };

    #### NixOS ####
    # maps to systemd service and nftables/iptables firewall
    nixos = lib.mkIf pkgs.stdenv.isLinux {
      services.tailscale = {
        enable = true;
        package = pkgs.tailscale;
        openFirewall = true;
        extraUpFlags = config.tailscaleUpFlags;
        extraDaemonFlags = cfg.extraDaemonFlags;
        authKeyFile = lib.mkIf (cfg.authKeyFile != null) cfg.authKeyFile;
        # Optional: simplified routing knob on NixOS, align with our booleans
        useRoutingFeatures =
          if cfg.advertiseExitNode then "server"
          else if cfg.acceptRoutes then "client"
          else "none";
      };
    };
  };
}
