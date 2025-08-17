{ pkgs, ... }:

{
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    konsole
    elisa
    khelpcenter
  ];

  programs.kdeconnect.enable = true;
}
