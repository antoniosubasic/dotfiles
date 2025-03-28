{
  programs.plasma.window-rules = [
    {
      description = "Discord - Virtual Desktop 2";
      match = {
        window-class = {
          value = "discord";
          type = "exact";
          match-whole = false;
        };
        window-types = [
          "normal"
          "desktop"
          "dock"
          "toolbar"
          "torn-of-menu"
          "dialog"
          "menubar"
          "utility"
          "spash"
          "osd"
        ];
      };
      apply = {
        desktops = {
          value = "Desktop_2";
          apply = "initially";
        };
      };
    }
    {
      description = "VS Code - URL Handler";
      match = {
        window-class = {
          value = "Code";
          type = "substring";
          match-whole = true;
        };
        window-types = [
          "normal"
          "desktop"
          "dock"
          "toolbar"
          "torn-of-menu"
          "dialog"
          "menubar"
          "utility"
          "spash"
          "osd"
        ];
      };
      apply = {
        desktopfile = {
          value = "/etc/profiles/per-user/antonio/share/applications/code.desktop";
          apply = "initially";
        };
      };
    }
  ];
}
