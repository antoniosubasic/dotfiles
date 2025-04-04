{
  utils,
  pkgs,
  lib,
  ...
}:

lib.optionalAttrs (utils.hasTag "personal") {
  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  fonts.fontconfig.enable = true;
}
