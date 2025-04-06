{
  utilities,
  pkgs,
  lib,
  ...
}:

lib.optionalAttrs (utilities.hasTag "personal") {
  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  fonts.fontconfig.enable = true;
}
