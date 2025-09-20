let
  toPath =
    path:
    builtins.path {
      inherit path;
      name = builtins.baseNameOf (toString path);
    };
in
{
  programs.plasma = {
    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
      theme = "breeze-dark";
      colorScheme = "BreezeDark";
    };
    kwin.effects.shakeCursor.enable = false;
    configFile.kwinrc.Effect-overview.BorderActivate = 9;
    kscreenlocker.appearance.wallpaper = toPath ./appearance/lockscreen.png;
    workspace.wallpaper = toPath ./appearance/desktop.png;
  };

  home.file.".face.icon".source = ./appearance/avatar.png;
}
