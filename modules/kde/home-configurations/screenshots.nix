{
  programs.plasma = {
    spectacle = {
      shortcuts = {
        captureRectangularRegion = "Print";
        captureCurrentMonitor = "Shift+Print";
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
