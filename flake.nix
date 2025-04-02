{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      plasma-manager,
      ...
    }:
    let
      lib = nixpkgs.lib;

      machines = builtins.attrNames (
        lib.filterAttrs (name: type: type == "directory") (builtins.readDir ./machines)
      );

      mkSystem =
        hostname:
        let
          configPath = ./machines/${hostname}/configuration.nix;
          config = {
            username = "antonio";
            desktop = "kde";
            system = "x86_64-linux";
          } // (if builtins.pathExists configPath then import configPath else { });

          args = config // {
            inherit hostname;
            utilities = import ./lib/utils.nix { inherit lib; };
            unstable = import nixpkgs-unstable {
              system = config.system;
              config.allowUnfree = true;
            };
          };
        in
        nixpkgs.lib.nixosSystem {
          system = config.system;
          specialArgs = args;
          modules = [
            ./machines/${hostname}/hardware-configuration.nix
            ./modules/configuration.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = args;
              home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];
              home-manager.users.${config.username} = import ./modules/home.nix;
            }
          ];
        };
    in
    {
      nixosConfigurations = lib.genAttrs machines (name: mkSystem name);
    };
}
