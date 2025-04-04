{ utils, lib, ... }:

{
  imports =
    utils.importNixFiles ./configurations
    ++ lib.optionals (utils.hasTag "kde") [
      ./kde/configuration.nix
    ];
}
