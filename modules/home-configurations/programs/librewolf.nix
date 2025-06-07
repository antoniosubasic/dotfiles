{ utilities, ... }:

{
  programs.librewolf = {
    enable = utilities.hasTags [
      "gui"
      "personal"
    ];
    settings = {
      "browser.toolbars.bookmarks.visibility" = "never";
      "sidebar.visibility" = "hide-sidebar";
    };
  };
}
