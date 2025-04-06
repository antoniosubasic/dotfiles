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

      tagGroups = rec {
        desktop = [
          "nvidia"
        ] ++ user;
        laptop = [
          "fingerprint"
        ] ++ user;
        user = [
          "personal"
          "shell"
          "dev"
          "kde"
          "unfree"
          "dual-boot"
          "bluetooth"
        ];
      };

      baseTags = [
        "personal"
        "fingerprint"
        "shell"
        "dev"
        "kde"
        "nvidia"
        "unfree"
        "dual-boot"
        "bluetooth"
      ];

      mkSystem =
        hostname:
        let
          configPath = ./machines/${hostname}/configuration.nix;
          config = {
            username = "antonio";
            system = "x86_64-linux";
          } // (if builtins.pathExists configPath then import configPath else { });

          givenTags =
            if !(builtins.hasAttr "tags" config) then
              builtins.abort "error: missing required 'tags' attribute in '${hostname}' configuration"
            else if !(builtins.isList config.tags) then
              builtins.abort "error: 'tags' attribute must be a list"
            else if builtins.length config.tags == 0 then
              builtins.abort "error: 'tags' attribute must not be empty"
            else
              config.tags;

          flattenTags =
            tags:
            lib.flatten (
              map (
                tag:
                if builtins.isString tag && builtins.hasAttr tag tagGroups then
                  flattenTags tagGroups.${tag}
                else if builtins.isString tag && builtins.elem tag baseTags then
                  tag
                else
                  builtins.abort "error: unknown tag '${tag}'"
              ) tags
            );

          args = config // rec {
            inherit hostname;
            tags = flattenTags givenTags;
            utilities = import ./lib/utils.nix { inherit lib tags; };
            unstable = import nixpkgs-unstable {
              system = config.system;
              config.allowUnfree = utilities.hasTag "unfree";
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
