{ pkgs, utilities, ... }:

{
  programs.bat = {
    enable = utilities.hasTag "shell";
    extraPackages = with pkgs.bat-extras; [
      batman
      batdiff
    ];
  };
}
