{ utilities, lib, ... }:

{
  imports =
    utilities.importNixFiles ./configurations
    ++ lib.optionals (utilities.hasTag "kde") [
      ./kde/configuration.nix
    ];
}
