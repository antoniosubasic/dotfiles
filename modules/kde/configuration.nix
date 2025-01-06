{ pkgs, username, ... }:

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

    systemPackages = [
      (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
        [General]
        background=${../home-configurations/files/images/lockscreen.png}
      '')
      (pkgs.symlinkJoin {
        name = "sddm-face-icon";
        paths = [
          (pkgs.runCommand "sddm-face-icon" { } ''
            mkdir -p $out/share/sddm/faces
            cp ${../home-configurations/files/images/avatar.png} $out/share/sddm/faces/${username}.face.icon
          '')
        ];
      })
    ];
  };
}
