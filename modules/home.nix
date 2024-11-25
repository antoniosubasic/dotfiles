{ config, pkgs, ... }:

{
  home-manager.users.antonio = {
    home.stateVersion = "24.05";

    home.username = "antonio";
    home.homeDirectory = "/home/antonio";

    programs.home-manager.enable = true;

    programs.git = {
        enable = true;
        userName = "Antonio Subašić";
        userEmail = "antonio.subasic.as@gmail.com";
    };
  };
}