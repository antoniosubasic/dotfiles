{
  programs.plasma = {
    workspace.colorScheme = "BreezeDark";
    kwin.effects.shakeCursor.enable = false;
    configFile.kwinrc.Effect-overview.BorderActivate = 9;
  };

  home.file.".face.icon".source = ./appearance/avatar.png;
}
