{ username }: { config, pkgs, lib, ... }:

let
  inherit (lib.strings) toLower replaceStrings;

  configs = [
    {
      file = "kdeglobals";
      config = {
        General.ColorScheme = "BreezeDark";
      };
    }
    {
      file = "kglobalshortcutsrc";
      config = {
        services = {
          "Alacritty.desktop"._launch = "Ctrl+Alt+T";
          "org.kde.kalk.desktop"._launch = "Calculator";
          "net.local.printf.desktop"._launch = "Ctrl+Alt+S";
        };
        kwin = {
          "Switch One Desktop Down" = "Meta+J,none,Switch One Desktop Down";
          "Switch One Desktop Up" = "Meta+K,none,Switch One Desktop Up";
          "Switch One Desktop to the Left" = "Meta+H,none,Switch One Desktop to the Left";
          "Switch One Desktop to the Right" = "Meta+L,none,Switch One Desktop to the Right";
          "Window Maximize" = "Meta+Up,none,Maximize Window";
          "Window One Desktop Down" = "Meta+Shift+J,none,Window One Desktop Down";
          "Window One Desktop Up" = "Meta+Shift+K,none,Window One Desktop Up";
          "Window One Desktop to the Left" = "Meta+Shift+H,none,Window One Desktop to the Left";
          "Window One Desktop to the Right" = "Meta+Shift+L,none,Window One Desktop to the Right";
        };
        ksmserver = {
          "Lock Session" = "Ctrl+Alt+L,Meta+L\\tScreensaver,Lock Session";
        };
      };
    }
    {
      file = "plasma-org.kde.plasma.desktop-appletsrc";
      config = {
        Containments = {
          "1".Wallpaper."org.kde.image".General.Image = "/home/${username}/.wallpaper/desktop.png";
          "2".Applets = {
            "19".Configuration.Appearance = {
              dateFormat = "custom";
              customDateFormat = "ddd dd MMM";
              showSeconds = "Always";
            };
            "5".Configuration.General = {
              launchers = "preferred://filemanager,applications:code.desktop,applications:discord.desktop,applications:google-chrome.desktop";
              wheelEnabled = "false";
            };
          };
          "8".General = {
            hiddenItems = "org.kde.plasma.brightness";
            shownItems = "org.kde.plasma.volume,org.kde.plasma.bluetooth,org.kde.plasma.clipboard,org.kde.plasma.notifications";
          };
        };
      };
    }
    {
      file = "kwinrc";
      config = {
        "Effect-overview".BorderActivate = "9";
        Plugins.shakecursorEnabled = "false";
        "org.kde.kdecoration2".ButtonsOnLeft = "M";
        Xwayland.Scale = "1.85";
      };
    }
    {
      file = "dolphinrc";
      config = {
        DetailsMode.ExpandableFolders = "false";
        General = {
          ConfirmClosingMultipleTabs = "false";
          OpenExternallyCalledFolderInNewTab = "true";
          RememberOpenedTabs = "false";
          ShowFullPath = "true";
          SortingChoice = "CaseInsensitiveSorting";
        };
        MainWindow = {
          MenuBar = "Disabled";
          ToolBarsMovable = "Disabled";
        };
        PreviewSettings.Plugins = "appimagethumbnail,audiothumbnail,comicbookthumbnail,cursorthumbnail,djvuthumbnail,ebookthumbnail,exrthumbnail,directorythumbnail,fontthumbnail,imagethumbnail,jpegthumbnail,jxl,kraorathumbnail,windowsexethumbnail,windowsimagethumbnail,opendocumentthumbnail,svgthumbnail,gdk-pixbuf-thumbnailer";
        Search.Location = "Everywhere";
      };
    }
    {
      file = "krunnerrc";
      config = {
        General.FreeFloating = "true";
        Plugins.krunner_konsoleprofilesEnabled = "false";
        Plugins.Favorites.plugins = "krunner_services,krunner_systemsettings";
      };
    }
    {
      file = "powerdevil.notifyrc";
      config = {
        "Event/lowperipheralbattery".Action = "";
      };
    }
    {
      file = "bluedevilglobalrc";
      config = {
        Global.launchState = "enable";
      };
    }
    {
      file = "mimeapps.list";
      config = {
        "Added Associations" = {
          "application/pdf" = "google-chrome.desktop";
          "image/png" = "google-chrome.desktop";
          "image/svg+xml" = "google-chrome.desktop";
          "text/plain" = "code.desktop";
          "x-scheme-handler/geo" = "google-maps-geo-handler.desktop";
        };
        "Default Applications" = {
          "application/pdf" = "google-chrome.desktop";
          "image/png" = "google-chrome.desktop";
          "image/svg+xml" = "google-chrome.desktop";
          "text/html" = "google-chrome.desktop";
          "text/plain" = "code.desktop";
          "x-scheme-handler/geo" = "google-maps-geo-handler.desktop";
          "x-scheme-handler/http" = "google-chrome.desktop";
          "x-scheme-handler/https" = "google-chrome.desktop";
          "x-scheme-handler/mailto" = "google-chrome.desktop";
        };
      };
    }
    {
      file = "plasmanotifyrc";
      config = {
        Services.donationmessage = {
          ShowInHistory = "false";
          ShowPopups = "false";
        };
      };
    }
    {
      file = "ktrashrc";
      config = {
        "/home/${username}/.local/share/Trash" = {
          Days = "100";
          LimitReachedAction = "0";
          Percent = "10";
          UseSizeLimit = "true";
          UseTimeLimit = "true";
        };
      };
    }
    {
      file = "plasmaparc";
      config = {
        General.AudioFeedback = "false";
      };
    }
    {
      file = "kscreenlockerrc";
      config = {
        Daemon = {
          LockGrace = "0";
          Timeout = "10";
        };
        Greeter.Wallpaper."org.kde.image".General = {
          Image = "/home/${username}/.wallpaper/lockscreen.png";
          PreviewImage = "/home/${username}/.wallpaper/lockscreen.png";
        };
      };
    }
    {
      file = "kcminputrc";
      config = {
        Keyboard.NumLock = "0";
      };
    }
    {
      file = "kwinrulesrc";
      config = {
        General = {
          count = "1";
          rules = "b91a3f7a-0618-448f-a814-fad4bfaf1d2c";
        };
        "b91a3f7a-0618-448f-a814-fad4bfaf1d2c" = {
          Description = "Application settings for Discord";
          desktops = "a36c2ddd-367b-4d66-bf7c-1441085e4dce";
          desktopsrule = "3";
          wmclass = "discord";
          wmclassmatch = "1";
        };
      };
    }
    {
      file = "ksmserverrc";
      config = {
        General = {
          confirmLogout = "false";
          loginMode = "emptySession";
        };
      };
    }
    {
      file = "/home/${username}/.local/share/applications/net.local.printf.desktop";
      config = {
        "Desktop Entry" = {
          Exec = "printf \"Subašić\" | xsel --clipboard --input && notify-send --app-name \"surname\" \"copied\" || notify-send --app-name \"surname\" \"failed\"";
          Name = "Copy surname to clipboard";
          NoDisplay = "true";
          StartupNotify = "false";
          Type = "Application";
          "X-KDE-GlobalAccel-CommandShortcut" = "true";
        };
      };
    }
  ];

  searchProviders = map (provider: {
    file = "/home/${username}/.local/share/kf6/searchproviders/${toLower (replaceStrings [" "] ["_"] provider.name)}.desktop";
    config = {
      "Desktop Entry" = {
        Charset = "";
        Hidden = "false";
        Keys = provider.shortcut;
        Name = provider.name;
        Query = provider.query;
        Type = "Service";
      };
    };
  }) [
    {
      name = "GitHub";
      shortcut = "!gh";
      query = "https://github.com/search?q=\\{@}";
    }
    {
      name = "Personal GitHub";
      shortcut = "!pgh";
      query = "https://github.com/antoniosubasic?tab=repositories&q=\\{@}";
    }
    {
      name = "Google";
      shortcut = "!g";
      query = "https://www.google.com/search?q=\\{@}";
    }
    {
      name = "Google Images";
      shortcut = "!gi";
      query = "https://www.google.com/search?site=imghp&tbm=isch&q=\\{@}";
    }
    {
      name = "Google Maps";
      shortcut = "!gm";
      query = "https://www.google.com/maps/search/\\{@}";
    }
    {
      name = "YouTube";
      shortcut = "!yt";
      query = "https://www.youtube.com/results?search_query=\\{@}";
    }
    {
      name = "WikiPedia";
      shortcut = "!wp";
      query = "https://en.wikipedia.org/wiki/Special:Search?search=\\{@}";
    }
    {
      name = "Wolfram Alpha";
      shortcut = "!wa";
      query = "https://www.wolframalpha.com/input/?i=\\{@}";
    }
  ];



  #! HELPER FUNCTIONS

  init = list: 
    if list == [] then []
    else if builtins.length list == 1 then []
    else [(builtins.head list)] ++ init (builtins.tail list);

  last = list:
    if list == [] then null
    else if builtins.length list == 1 then builtins.head list
    else last (builtins.tail list);

  flattenAttrs = prefix: set:
    builtins.concatLists (
      builtins.map (name:
        let 
          value = set.${name};
          newPrefix = prefix ++ [name];
        in
          if builtins.isAttrs value then
            flattenAttrs newPrefix value
          else
            [{ path = newPrefix; value = value; }]
      ) (builtins.attrNames set)
    );

  generateBuildGroups = path:
    builtins.concatStringsSep " " (
      builtins.map (name: "--group \"${name}\"") 
        (init path)
    );

  generateBuildCommands = configs:
    builtins.concatStringsSep "\n" (
      builtins.map (cfg:
        let
          flattened = flattenAttrs [] cfg.config;
          commands = builtins.map (item: 
            "${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file \"${cfg.file}\" ${generateBuildGroups item.path} --key \"${last item.path}\" \"${toString item.value}\""
          ) flattened;
        in
          builtins.concatStringsSep "\n" commands
      ) configs
    );
in
{
  home = {
    packages = with pkgs.kdePackages; [
      kalk
    ];

    file = {
      ".wallpaper".source = ../global/images;
      ".face.icon".source = ../global/images/avatar.png;

      # needed because kwriteconfig6 does not allow unescaped characters like '\s'
      ".config/kuriikwsfilterrc".text = ''
        [General]
        DefaultWebShortcut=google
        EnableWebShortcuts=true
        KeywordDelimiter=\s
        PreferredWebShortcuts=google,google_images,google_maps,wikipedia,wolfram_alpha,youtube
        UsePreferredWebShortcutsOnly=false
      '';

      ".config/google-chrome/NativeMessagingHosts/org.kde.plasma.browser_integration.json".source =
        "${pkgs.plasma-browser-integration}/etc/chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json";
    };

    activation.KDESettings = lib.mkAfter ''
      ${generateBuildCommands (configs ++ searchProviders)}
    '';
  };
}