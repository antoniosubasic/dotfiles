{ utils, lib, ... }:

{
  imports =
    utils.importNixFiles ./home-configurations
    ++ lib.mkIf (utils.hasTag "kde") [
      ./kde/home.nix
    ];
}
