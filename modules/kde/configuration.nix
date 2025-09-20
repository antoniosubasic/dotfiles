{ pkgs, utilities, ... }:

rec {
  imports = utilities.importNixFiles ./configurations;

  services = {
    displayManager.sddm = {
      enable = true;
      theme = "breeze";
    };
    desktopManager.plasma6.enable = true;
  };

  environment.systemPackages = [
    (pkgs.writeTextDir "share/sddm/themes/${services.displayManager.sddm.theme}/theme.conf.user" ''
      [General]
      background=${builtins.path { path = ./home-configurations/appearance/lockscreen.png; }}
    '')
  ];
}
