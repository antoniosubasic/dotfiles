{
  lib,
  utilities,
  pkgs,
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
