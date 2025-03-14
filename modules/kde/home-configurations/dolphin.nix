{ username, ... }:

{
  programs.plasma.configFile = {
    dolphinrc = {
      DetailsMode = {
        ExpandableFolders = false;
        PreviewSize = 22;
      };
      General = {
        ConfirmClosingMultipleTabs = false;
        OpenExternallyCalledFolderInNewTab = true;
        RememberOpenedTabs = false;
        ShowFullPath = true;
        SortingChoice = "CaseInsensitiveSorting";
      };
      MainWindow = {
        MenuBar = "Disabled";
        ToolBarsMovable = "Disabled";
      };
      PreviewSettings.Plugins = "appimagethumbnail,audiothumbnail,comicbookthumbnail,cursorthumbnail,djvuthumbnail,ebookthumbnail,exrthumbnail,directorythumbnail,fontthumbnail,imagethumbnail,jpegthumbnail,jxl,kraorathumbnail,windowsexethumbnail,windowsimagethumbnail,opendocumentthumbnail,svgthumbnail,gdk-pixbuf-thumbnailer";
      Search.Location = "Everywhere";
    };
    ktrashrc = {
      "/home/${username}/.local/share/Trash" = {
        Days = 100;
        LimitReachedAction = 0;
        Percent = 10;
        UseSizeLimit = true;
        UseTimeLimit = true;
      };
    };
  };
}
