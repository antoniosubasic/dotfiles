{
  description = "NixOS custom modules";

  outputs =
    { ... }:
    let
      contents = builtins.readDir ./.;
      directories = builtins.filter (name: contents.${name} == "directory") (builtins.attrNames contents);
    in
    {
      nixosModules.customModules = {
        imports = map (dir: ./${dir}) directories;
      };
    };
}
