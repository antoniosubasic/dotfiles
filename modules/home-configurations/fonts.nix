{
  utils,
  pkgs,
  lib,
  ...
}:

lib.mkIf (utils.hasTag "personal") {
  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  fonts.fontconfig.enable = true;
}
