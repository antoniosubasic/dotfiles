{ lib, utilities, ... }:

{
  programs.plasma.window-rules = [
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
    {
      description = "Fullscreen";
      match = {
        window-class = {
          value = "Google Chrome|Code";
          type = "regex";
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
      apply = rec {
        maximizehoriz = {
          value = true;
          apply = "initially";
        };
        maximizevert = maximizehoriz;
      };
    }
  ]
  ++ lib.optionals (utilities.hasTag "virtual_desktops") [
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
  ]
  ++ lib.optionals (!(utilities.hasTag "virtual_desktops")) [
    {
      description = "Discord - Desktop Monitor 2";
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
        screen = {
          value = 0;
          apply = "initially";
        };
        ignoregeometry = {
          value = true;
          apply = "initially";
        };
      };
    }
  ];
}
