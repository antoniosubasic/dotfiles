{ pkgs, ... }:

{
  services = {
    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;
  };

  environment = {
    plasma6.excludePackages = with pkgs.kdePackages; [
      konsole
      elisa
      gwenview
      okular
      khelpcenter
    ];
  };
}
