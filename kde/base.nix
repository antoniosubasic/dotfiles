{ config, pkgs, username, ... }:

{
  services.displayManager.sddm.enable = true;
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
      background=${../global/files/images/lockscreen.png}
    '')
    (pkgs.symlinkJoin {
      name = "sddm-face-icon";
      paths = [
        (pkgs.runCommand "sddm-face-icon" {} ''
          mkdir -p $out/share/sddm/faces
          cp ${../global/files/images/avatar.png} $out/share/sddm/faces/${username}.face.icon
        '')
      ];
    })
  ];
}