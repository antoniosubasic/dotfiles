{
  programs.plasma = {
    spectacle = {
      shortcuts = {
        captureRectangularRegion = [ "Print" "Meta+Shift+S" ];
        captureCurrentMonitor = "Shift+Print";
        launch = "Meta+S";
      };
    };
    configFile.spectaclerc = {
      General.clipboardGroup = "PostScreenshotCopyImage";
      GuiConfig = {
        captureMode = 0;
        quitAfterSaveCopyExport = true;
      };
      ImageSave.translatedScreenshotsFolder = "Screenshots";
      VideoSave = {
        preferredVideoFormat = 2;
        translatedScreencastsFolder = "Screencasts";
      };
    };
  };
}
