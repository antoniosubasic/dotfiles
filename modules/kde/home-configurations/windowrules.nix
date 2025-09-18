{ lib, userVars, ... }:

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
  ++
    lib.optionals
      (builtins.elem userVars.virtual_desktops [
        1
        2
      ])
      [
        {
          description = "Discord - 2nd ${
            if userVars.virtual_desktops == 1 then "Desktop Monitor" else "Virtual Desktop"
          }";
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
          apply =
            if userVars.virtual_desktops == 1 then
              {
                screen = {
                  value = 0;
                  apply = "initially";
                };
                ignoregeometry = {
                  value = true;
                  apply = "initially";
                };
              }
            else
              {
                desktops = {
                  value = "Desktop_2";
                  apply = "initially";
                };
              };
        }
      ];
}
