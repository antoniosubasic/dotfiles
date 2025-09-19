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
    workspace.colorScheme = "BreezeDark";
    kwin.effects.shakeCursor.enable = false;
    configFile.kwinrc.Effect-overview.BorderActivate = 9;
    kscreenlocker.appearance.wallpaper = toPath ./appearance/lockscreen.png;
    workspace.wallpaper = toPath ./appearance/desktop.png;
  };

  home.file.".face.icon".source = ./appearance/avatar.png;
}
