{ pkgs, ... }:

{
  home.packages = with pkgs.kdePackages; [
    kalk
    kdenlive
  ];
}
