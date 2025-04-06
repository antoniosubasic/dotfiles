{ utilities, pkgs, ... }:

{
  programs.bat = {
    enable = utilities.hasTag "shell";
    extraPackages = with pkgs.bat-extras; [
      batgrep
      batman
      prettybat
      batdiff
    ];
  };
}
