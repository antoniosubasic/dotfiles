{ pkgs, utilities, ... }:

rec {
  imports = utilities.importNixFiles ./configurations;

  services = {
    displayManager.sddm = {
      enable = true;
      theme = "breeze";
      wayland = {
        enable = true;
        compositor = "kwin";
      };
    };
    desktopManager.plasma6.enable = true;
  };

  environment.systemPackages = [
    (pkgs.writeTextDir "share/sddm/themes/${services.displayManager.sddm.theme}/theme.conf.user" ''
      [General]
      background=${builtins.path { path = ./home-configurations/appearance/lockscreen.png; }}
    '')
    (pkgs.runCommand "sddm-avatar" { } ''
      mkdir -p $out/share/sddm/themes/${services.displayManager.sddm.theme}/faces
      cp ${./home-configurations/appearance/avatar.png} $out/share/sddm/themes/${services.displayManager.sddm.theme}/faces/.face.icon
    '')
  ];
}
