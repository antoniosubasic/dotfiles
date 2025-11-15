{ pkgs, ... }:

let
  toPath =
    path:
    builtins.path {
      inherit path;
      name = builtins.baseNameOf (toString path);
    };
in
{
  programs.plasma = rec {
    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
      theme = "breeze-dark";
      colorScheme = "BreezeDark";
    };
    kwin.effects.shakeCursor.enable = true;
    configFile.kwinrc.Effect-overview.BorderActivate = 9;
    kscreenlocker.appearance.wallpaper = workspace.wallpaper;
    workspace.wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Patak/contents/images_dark/3840x2160.png";
  };

  home.file.".face.icon".source = ./appearance/avatar.png;
}
