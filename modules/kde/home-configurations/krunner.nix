{ username, lib, ... }:

let
  mkSearchProvider =
    {
      name,
      shortcut,
      query,
    }:
    {
      name = "/home/${username}/.local/share/kf6/searchproviders/${
        lib.strings.toLower (lib.strings.replaceStrings [ " " ] [ "_" ] name)
      }.desktop";
      value = {
        text = ''
          [Desktop Entry]
          Charset=
          Hidden=false
          Keys=${shortcut}
          Name=${name}
          Query=${query}
          Type=Service
        '';
      };
    };

  searchProviders = [
    {
      name = "GitHub";
      shortcut = "gh";
      query = "https://github.com/search?q=\\{@}";
    }
    {
      name = "Personal GitHub";
      shortcut = "pgh";
      query = "https://github.com/antoniosubasic?tab=repositories&q=\\{@}";
    }
    {
      name = "Google";
      shortcut = "g";
      query = "https://www.google.com/search?q=\\{@}";
    }
    {
      name = "Google Drive";
      shortcut = "gd";
      query = "https://drive.google.com/drive/search?q=\\{@}";
    }
    {
      name = "Google Images";
      shortcut = "gi";
      query = "https://www.google.com/search?site=imghp&tbm=isch&q=\\{@}";
    }
    {
      name = "Google Maps";
      shortcut = "gm";
      query = "https://www.google.com/maps/search/\\{@}";
    }
    {
      name = "YouTube";
      shortcut = "yt";
      query = "https://www.youtube.com/results?search_query=\\{@}";
    }
    {
      name = "WikiPedia";
      shortcut = "wp";
      query = "https://en.wikipedia.org/wiki/Special:Search?search=\\{@}";
    }
    {
      name = "Wolfram Alpha";
      shortcut = "wa";
      query = "https://www.wolframalpha.com/input/?i=\\{@}";
    }
  ];
in
{
  programs.plasma = {
    krunner = {
      position = "center";
      historyBehavior = "enableSuggestions";
    };
    configFile = {
      krunnerrc = {
        Plugins.krunner_konsoleprofilesEnabled = false;
        "Plugins/Favorites".plugins = "krunner_services,krunner_systemsettings";
      };
      kuriikwsfilterrc = {
        General = {
          DefaultWebShortcut = "google";
          EnableWebShortcuts = true;
          KeywordDelimiter = {
            value = "\\s";
            escapeValue = false;
          };
          PreferredWebShortcuts = "google,google_drive,google_images,google_maps,wikipedia,wolfram_alpha,youtube";
          UsePreferredWebShortcutsOnly = false;
        };
      };
    };
  };
  home.file = builtins.listToAttrs (map mkSearchProvider searchProviders);
}
