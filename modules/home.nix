# imported in flake.nix

{ config, pkgs, username, ... }:

{
  home.stateVersion = "24.05";

  home.username = "${username}";
  home.homeDirectory = "/home/${username}";

  programs.home-manager.enable = true;
  
  imports = (import ./home-manager);
}