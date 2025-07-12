{
  description = "NixOS custom modules";

  outputs =
    { ... }:
    {
      nixosModules.customModules = {
        imports = [
          ./sqldeveloper
        ];
      };
    };
}
