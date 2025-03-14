{ pkgs, utilities, ... }:

{
  imports = utilities.importNixFiles ./home-configurations;
  programs.plasma.enable = true;

  home.packages = with pkgs.kdePackages; [
    kalk
  ];
}
