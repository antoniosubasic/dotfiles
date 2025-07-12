{
  pkgs,
  lib,
  utilities,
  ...
}:

lib.optionalAttrs
  (utilities.hasTags [
    "gui"
    "personal"
  ])
  {
    home.packages = [ pkgs.keepassxc ];
  }
