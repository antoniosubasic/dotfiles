{ utilities, ... }:

{
  programs.librewolf = {
    enable = utilities.hasTags [
      "gui"
      "personal"
    ];
    settings = {
      "sidebar.visibility" = "hide-sidebar";
      "privacy.clearOnShutdown.history" = true;
      "privacy.clearOnShutdown.formdata" = true;
      "privacy.clearOnShutdown_v2.browsingHistoryAndDownloads" = true;
      "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = true;
      "privacy.clearOnShutdown_v2.formdata" = true;
    };
  };
}
