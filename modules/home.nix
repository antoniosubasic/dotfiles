{ config, pkgs, username, ... }:

{
  home.stateVersion = "24.05";

  home.username = "${username}";
  home.homeDirectory = "/home/${username}";

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "Antonio Subašić";
    userEmail = "antonio.subasic.as@gmail.com";
  };
}