{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = let
      hostsPath = ./hosts;
      modulesPath = ./modules;
      hosts = [ "test-laptop" ];
    in nixpkgs.lib.genAttrs hosts (host: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          home-manager.nixosModules.home-manager
          { networking.hostName = host; }
        ]
        ++ (import modulesPath)
        ++ (import "${hostsPath}/${host}");
      });
  };
}