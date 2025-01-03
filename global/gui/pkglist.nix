{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    google-chrome
    vscode
    discord
    dropbox
    libreoffice-still
    keepassxc
    jetbrains.idea-ultimate
    jetbrains.datagrip
  ];
}
