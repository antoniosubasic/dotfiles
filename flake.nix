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

  outputs = inputs@{ nixpkgs, home-manager, ... }:
  let
    username = "antonio";
    system = "x86_64-linux";

    mkSystem = hostname: desktop: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit username hostname; };
      modules = [
        ./machines/${hostname}/hardware-configuration.nix
        ./global/base.nix
        ./${desktop}/base.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${username} = nixpkgs.lib.mkMerge [
            (import ./global/home.nix { inherit username; })
            (import ./${desktop}/home.nix { inherit username; })
          ];
        }
      ];
    };
  in {
    nixosConfigurations = {
      dell-inspiron = mkSystem "dell-inspiron" "kde";
    };
  };
}
