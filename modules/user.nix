{ config, pkgs, ... }:

{
  users.users.antonio = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    home = "/home/antonio";
    description = "Antonio";
  }
}