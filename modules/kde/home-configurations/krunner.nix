{
  programs.plasma = {
    krunner = {
      position = "center";
      historyBehavior = "enableSuggestions";
    };
    configFile.krunnerrc.Plugins = {
      krunner_konsoleprofilesEnabled = false;
      Favorites.plugins = "krunner_services,krunner_systemsettings";
    };
  };
}
