{ config, pkgs, ... }:

{
  services.displayManager.sddm = {
    enable = true;
    autoNumlock = true;
  };
  services.desktopManager.plasma6.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    konsole
    elisa
    gwenview
    okular
    khelpcenter
  ];

  environment.systemPackages = [
    (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
      [General]
      background=${../wallpaper/lockscreen.png}
    '')
  ];
}