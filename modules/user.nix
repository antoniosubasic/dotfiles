{ config, pkgs, username, ... }:

{
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    home = "/home/${username}";
    description = "Antonio";
  }
}