{
  programs.plasma = {
    kscreenlocker.appearance.wallpaper = ../../home-configurations/files/images/lockscreen.png;
    workspace = {
      wallpaper = ../../home-configurations/files/images/desktop.png;
      colorScheme = "BreezeDark";
    };
    kwin.effects.shakeCursor.enable = false;
    configFile.kwinrc = {
      Effect-overview.BorderActivate = 9;
      Xwayland.Scale = "1.85";
    };
  };
}
