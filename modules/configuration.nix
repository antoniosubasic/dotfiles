{ utils, lib, ... }:

{
  imports =
    lib.optionals (utils.hasTag "kde") [
      ./kde/configuration.nix
    ]
    ++ utils.importNixFiles ./configurations;
}
