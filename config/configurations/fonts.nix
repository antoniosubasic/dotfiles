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
    fonts = {
      packages = with pkgs; [
        nerd-fonts.jetbrains-mono
      ];
      fontconfig.enable = true;
      fontDir.enable = true;
    };
  }
