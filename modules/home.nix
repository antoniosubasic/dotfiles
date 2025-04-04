{ utils, lib, ... }:

{
  imports =
    utils.importNixFiles ./home-configurations
    ++ lib.optionals (utils.hasTag "kde") [
      ./kde/home.nix
    ];
}
