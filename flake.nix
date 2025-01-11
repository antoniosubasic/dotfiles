{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }:
    let
      hosts = {
        dell-inspiron = {
          username = "antonio";
          desktop = "kde";
          system = "x86_64-linux";
        };
      };

      lib = nixpkgs.lib;
      utilities = import ./lib/utils.nix { inherit lib; };

      unstable =
        hostname:
        import nixpkgs-unstable {
          system = hosts.${hostname}.system;
          config.allowUnfree = true;
        };

      mkSystem =
        name: config:
        let
          system = config.system;
          hostname = name;
          specialArgs = config // {
            inherit hostname utilities;
            unstable = unstable hostname;
          };
        in
        nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            ./machines/${hostname}/hardware-configuration.nix
            ./modules/configuration.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = specialArgs;
              home-manager.users.${config.username} = import ./modules/home.nix;
            }
          ];
        };
    in
    {
      nixosConfigurations = builtins.mapAttrs mkSystem hosts;
    };
}
