{
  programs.plasma = {
    kscreenlocker.appearance.wallpaper = ./appearance/lockscreen.png;
    workspace = {
      wallpaper = ./appearance/desktop.png;
      colorScheme = "BreezeDark";
    };
    kwin.effects.shakeCursor.enable = false;
    configFile.kwinrc = {
      Effect-overview.BorderActivate = 9;
      Xwayland.Scale = "1.85";
    };
  };

  # also see ../configuration.nix
  home.file.".face.icon".source = ./appearance/avatar.png;
}
