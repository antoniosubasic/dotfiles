{ utils, pkgs, ... }:

{
  programs.bat = {
    enable = utils.hasTag "shell";
    extraPackages = with pkgs.bat-extras; [
      batgrep
      batman
      prettybat
      batdiff
    ];
  };
}
