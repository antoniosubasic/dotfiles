{ pkgs, ... }:

{
  home.packages = with pkgs.kdePackages; [
    kalk
    dragon
  ];
}
