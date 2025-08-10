{
  description = "My nix config";

  inputs = {
    nixpkgs.url       = "github:NixOS/nixpkgs/nixos-25.05";
    nix-darwin.url    = "github:LnL7/nix-darwin";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, ... }:
    let
      systems = {
        navi   = "aarch64-darwin";
        makise = "x86_64-linux";
        vivy   = "x86_64-linux";
      };

      pkgsFor = system: import nixpkgs { inherit system; };
    in
    {
      nixosConfigurations = {
        makise = nixpkgs.lib.nixosSystem {
          system = systems.makise;
          modules = [
            ./hosts/common.nix
            ./hosts/makise/configuration.nix
            home-manager.nixosModules.home-manager
            { home-manager.users.net = import ./home/net.nix; }
          ];
        };

        vivy = nixpkgs.lib.nixosSystem {
          system = systems.vivy;
          modules = [
            ./hosts/common.nix
            ./hosts/vivy/configuration.nix
            home-manager.nixosModules.home-manager
            { home-manager.users.net = import ./home/net.nix; }
          ];
        };
      };

      darwinConfigurations = {
        navi = nix-darwin.lib.darwinSystem {
          system = systems.navi;
          modules = [
            ./hosts/common.nix
            ./hosts/navi/darwin.nix
            home-manager.darwinModules.home-manager
            {
              users.users.olivermcinnes.home = "/Users/olivermcinnes";
              home-manager.users.olivermcinnes = import ./home/olivermcinnes.nix;
            }
          ];
        };
      };

      devShells = builtins.mapAttrs (_: system:
        { default = (pkgsFor system).mkShell { buildInputs = [ (pkgsFor system).git ]; }; }
      ) systems;
    };
}
