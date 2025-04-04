{ pkgs, utils, ... }:

{
  imports = utils.importNixFiles ./home-configurations;
  programs.plasma.enable = true;

  home.packages = with pkgs.kdePackages; [
    kalk
  ];
}
