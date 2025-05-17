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
        (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      ];
      fontconfig.enable = true;
      fontDir.enable = true;
    };
  }
