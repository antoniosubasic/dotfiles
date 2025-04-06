{ utilities, lib, ... }:

{
  imports =
    utilities.importNixFiles ./home-configurations
    ++ lib.optionals (utilities.hasTag "kde") [
      ./kde/home.nix
    ];
}
