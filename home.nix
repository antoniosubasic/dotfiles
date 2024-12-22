{ config, pkgs, lib, ... }:

{
  home = {
    username = "antonio";
    homeDirectory = "/home/antonio";

    packages = with pkgs; [
      # packages
      man
      curl
      wget
      unzip
      docker-compose
      jq
      xsel
      ripgrep
      asciidoctor
      testdisk
      sl
      fzf
      eza
      kdePackages.kconfig
      kdePackages.kalk

      # applications
      google-chrome
      dropbox
      vscode
      jetbrains.idea-ultimate
      jetbrains.datagrip
      libreoffice-still
      discord
      keepassxc

      # languages
      gcc
      dotnet-sdk
      cargo
      rustc
      nodejs_23
      typescript
      temurin-bin
      maven

      # fonts
      (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];

    file = {
      ".config/nvim".source = ./dotfiles/nvim;
      ".config/bash".source = ./dotfiles/bash;
      ".local/share/kf6/searchproviders/github.desktop".text = ''
        [Desktop Entry]
        Charset=
        Hidden=false
        Keys=!gh
        Name=GitHub
        Query=https://github.com/search?q=\\{@}
        Type=Service
      '';
      ".local/share/kf6/searchproviders/personal_github.desktop".text = ''
        [Desktop Entry]
        Charset=
        Hidden=false
        Keys=!pgh
        Name=Personal GitHub
        Query=https://github.com/antoniosubasic?tab=repositories&q=\\{@}
        Type=Service
      '';
      ".local/share/kf6/searchproviders/google.desktop".text = ''
        [Desktop Entry]
        Charset=
        Hidden=false
        Keys=!g
        Name=Google
        Query=https://www.google.com/search?q=\\{@}
        Type=Service
      '';
      ".local/share/kf6/searchproviders/google_images.desktop".text = ''
        [Desktop Entry]
        Charset=
        Hidden=false
        Keys=!gi
        Name=Google Images
        Query=https://www.google.com/search?site=imghp&tbm=isch&q=\\{@}
        Type=Service
      '';
      ".local/share/kf6/searchproviders/google_maps.desktop".text = ''
        [Desktop Entry]
        Charset=
        Hidden=false
        Keys=!gm
        Name=Google Maps
        Query=https://www.google.com/maps/search/\\{@}
        Type=Service
      '';
      ".local/share/kf6/searchproviders/youtube.desktop".text = ''
        [Desktop Entry]
        Charset=
        Hidden=false
        Keys=!yt
        Name=YouTube
        Query=https://www.youtube.com/results?search_query=\\{@}
        Type=Service
      '';
      ".local/share/kf6/searchproviders/wikipedia.desktop".text = ''
        [Desktop Entry]
        Charset=
        Hidden=false
        Keys=!wp
        Name=WikiPedia
        Query=https://en.wikipedia.org/wiki/Special:Search?search=\\{@}
        Type=Service
      '';
      ".local/share/kf6/searchproviders/wolfram_alpha.desktop".text = ''
        [Desktop Entry]
        Charset=
        Hidden=false
        Keys=!wa
        Name=Wolfram Alpha
        Query=https://www.wolframalpha.com/input/?i=\\{@}
        Type=Service
      '';
      ".config/dolphinrc" = {
        text = ''
          [DetailsMode]
          ExpandableFolders=false

          [General]
          ConfirmClosingMultipleTabs=false
          OpenExternallyCalledFolderInNewTab=true
          RememberOpenedTabs=false
          ShowFullPath=true
          SortingChoice=CaseInsensitiveSorting
          Version=202
          ViewPropsTimestamp=2024,11,7,18,3,24.091

          [KFileDialog Settings]
          Places Icons Auto-resize=false
          Places Icons Static Size=22

          [MainWindow]
          MenuBar=Disabled
          ToolBarsMovable=Disabled

          [PreviewSettings]
          Plugins=appimagethumbnail,audiothumbnail,comicbookthumbnail,cursorthumbnail,djvuthumbnail,ebookthumbnail,exrthumbnail,directorythumbnail,fontthumbnail,imagethumbnail,jpegthumbnail,jxl,kraorathumbnail,windowsexethumbnail,windowsimagethumbnail,opendocumentthumbnail,svgthumbnail,gdk-pixbuf-thumbnailer

          [Search]
          Location=Everywhere
        '';
        force = true;
      };
      ".config/krunnerrc".text = ''
        [General]
        FreeFloating=true

        [Plugins]
        krunner_konsoleprofilesEnabled=false

        [Plugins][Favorites]
        plugins=krunner_services,krunner_systemsettings
      '';
      ".config/kuriikwsfiltersrc" = {
        text = ''
          [General]
          DefaultWebShortcut=google
          EnableWebShortcuts=true
          PreferredWebShortcuts=google,google_images,google_maps,wikipedia,wolfram_alpha,youtube
          UsePreferredWebShortcutsOnly=false
        '';
        force = true;
      };
      ".config/powerdevil.notifyrc".text = ''
        [Event/lowperipheralbattery]
        Action=
      '';
      ".config/mimeapps.list".text = ''
        [Added Associations]
        application/pdf=google-chrome.desktop;
        image/png=google-chrome.desktop;
        image/svg+xml=google-chrome.desktop;
        text/plain=code.desktop;
        x-scheme-handler/geo=google-maps-geo-handler.desktop;

        [Default Applications]
        application/pdf=google-chrome.desktop;
        image/png=google-chrome.desktop;
        image/svg+xml=google-chrome.desktop;
        text/html=google-chrome.desktop;
        text/plain=code.desktop;
        x-scheme-handler/geo=google-maps-geo-handler.desktop;
        x-scheme-handler/http=google-chrome.desktop
        x-scheme-handler/https=google-chrome.desktop
        x-scheme-handler/mailto=google-chrome.desktop
      '';
      ".config/plasmanotifyrc".text = ''
        [Services][donationmessage]
        ShowInHistory=false
        ShowPopups=false
      '';
      ".config/ktrashrc".text = ''
        [/home/antonio/.local/share/Trash]
        Days=100
        LimitReachedAction=0
        Percent=10
        UseSizeLimit=true
        UseTimeLimit=true
      '';
      ".config/plasmaparc".text = ''
        [General]
        AudioFeedback=false
      '';
      ".config/kscreenlockerrc".text = ''
        [Daemon]
        LockGrace=0
        Timeout=10

        [Greeter][Wallpaper][org.kde.image][General]
        Image=${toString ./wallpaper/lockscreen.png}
        PreviewImage=${toString ./wallpaper/lockscreen.png}
      '';
    };

    activation = {
      KDEShortcuts = lib.mkAfter ''
        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "kglobalshortcutsrc" --group "services" --group "Alacritty.desktop" --key "_launch" "Ctrl+Alt+T"

        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "kglobalshortcutsrc" --group "kwin" --key "Switch One Desktop Down" "Meta+J,none,Switch One Desktop Down"
        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "kglobalshortcutsrc" --group "kwin" --key "Switch One Desktop Up" "Meta+K,none,Switch One Desktop Up"
        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "kglobalshortcutsrc" --group "kwin" --key "Switch One Desktop to the Left" "Meta+H,none,Switch One Desktop to the Left"
        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "kglobalshortcutsrc" --group "kwin" --key "Switch One Desktop to the Right" "Meta+L,none,Switch One Desktop to the Right"

        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "kglobalshortcutsrc" --group "kwin" --key "Window Maximize" "Meta+Up,none,Maximize Window"

        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "kglobalshortcutsrc" --group "kwin" --key "Window One Desktop Down" "Meta+Shift+J,none,Window One Desktop Down"
        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "kglobalshortcutsrc" --group "kwin" --key "Window One Desktop Up" "Meta+Shift+K,none,Window One Desktop Up"
        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "kglobalshortcutsrc" --group "kwin" --key "Window One Desktop to the Left" "Meta+Shift+H,none,Window One Desktop to the Left"
        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "kglobalshortcutsrc" --group "kwin" --key "Window One Desktop to the Right" "Meta+Shift+L,none,Window One Desktop to the Right"

        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "kglobalshortcutsrc" --group "services" --group "Alacritty.desktop" --key "_launch" "Ctrl+Alt+T"
        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "kglobalshortcutsrc" --group "services" --group "org.kde.kalk.desktop" --key "_launch" "Calculator"

        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "plasma-org.kde.plasma.desktop-appletsrc" --group "Containments" --group "1" --group "Wallpaper" --group "org.kde.image" --group "General" --key "Image" "${toString ./wallpaper/desktop.png}"

        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "plasma-org.kde.plasma.desktop-appletsrc" --group "Containments" --group "2" --group "Applets" --group "19" --group "Configuration" --group "Appearance" --key "dateFormat" "custom"
        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "plasma-org.kde.plasma.desktop-appletsrc" --group "Containments" --group "2" --group "Applets" --group "19" --group "Configuration" --group "Appearance" --key "customDateFormat" "ddd dd MMM"
        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "plasma-org.kde.plasma.desktop-appletsrc" --group "Containments" --group "2" --group "Applets" --group "19" --group "Configuration" --group "Appearance" --key "showSeconds" "Always"
        
        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "plasma-org.kde.plasma.desktop-appletsrc" --group "Containments" --group "2" --group "Applets" --group "5" --group "Configuration" --group "General" --key "launchers" "preferred://filemanager,applications:code.desktop,applications:discord.desktop,applications:google-chrome.desktop"
        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "plasma-org.kde.plasma.desktop-appletsrc" --group "Containments" --group "2" --group "Applets" --group "5" --group "Configuration" --group "General" --key "wheelEnabled" "false"

        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "plasma-org.kde.plasma.desktop-appletsrc" --group "Containments" --group "8" --group "General" --key "hiddenItems" "org.kde.plasma.brightness"
        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "plasma-org.kde.plasma.desktop-appletsrc" --group "Containments" --group "8" --group "General" --key "shownItems" "org.kde.plasma.volume,org.kde.plasma.bluetooth,org.kde.plasma.clipboard,org.kde.plasma.notifications"
        
        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "kwinrc" --group "org.kde.kdecoration2" --key "ButtonsOnLeft" "M"
      '';
    };
  };

  fonts.fontconfig.enable = true;

  programs.git = {
    enable = true;
    userName = "Antonio Subašić";
    userEmail = "antonio.subasic.public@gmail.com";
    aliases = {
      cm = "commit -m";
      cp = "!f() { git clone git@github.com:$(git config user.github)/$1.git \${2:-$1}; }; f";
      transpose-ssh = "!f() { git remote set-url origin $(git remote get-url origin | sed 's|https://github.com/|git@github.com:|'); }; f";
      transpose-https = "!f() { git remote set-url origin $(git remote get-url origin | sed 's|git@github.com:|https://github.com/|'); }; f";
      tree = "log --graph --oneline --decorate --all";
      url = "!f() { git remote get-url origin | sed 's|git@github.com:|https://github.com/|'; }; f";
    };
    extraConfig = {
      user.github = "antoniosubasic";
      help.autocorrect = 10;
      url."git@github.com".insteadOf = "gh:";
      diff.algorithm = "histogram";
      status.submoduleSummary = true;
      core = { autocrlf = false; editor = "nvim"; };
      log.date = "iso";
      pull.ff = "only";
      push.autoSetupRemote = true;
      transfer.fsckobjects = true;
      fetch.fsckobjects = true;
      receive.fsckObjects = true;
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
      window = {
        dimensions = { columns = 125; lines = 30; };
        padding = { x = 10; y = 10; };
        decorations = "full";
        opacity = 0.99;
      };
      scrolling.history = 10000;
      selection.save_to_clipboard = true;
      font = {
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Italic";
        };
        bold_italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold Italic";
        };
      };
      keyboard.bindings = [
        { key = "N"; mods = "Control"; action = "SpawnNewInstance"; }
      ];
      colors = {
        primary = {
          background = "#1a1b26";
          foreground = "#a9b1d6";
        };
        normal = {
          black = "#32344a";
          red = "#f7768e";
          green = "#9ece6a";
          yellow = "#e0af68";
          blue = "#7aa2f7";
          magenta = "#ad8ee6";
          cyan = "#449dab";
          white = "#787c99";
        };
        bright = {
          black = "#444b6a";
          red = "#ff7a93";
          green = "#b9f27c";
          yellow = "#ff9e64";
          blue = "#7da6ff";
          magenta = "#bb9af7";
          cyan = "#0db9d7";
          white = "#acb0d0";
        };
      };
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = "[ -f ~/.config/bash/init.sh ] && source ~/.config/bash/init.sh";
    historySize = 1000;
    historyFileSize = 1000;
    historyControl = [
      "ignorespace"
      "ignoredups"
      "ignoreboth"
      "erasedups"
    ];
    historyIgnore = [
      "ls"
      "ll"
      "la"
      "l"
      "cd"
      "cd -"
      "pwd"
      "clear"
      "exit"
      "history"
      ":q"
    ];
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.bat = {
    enable = true;
    themes = {
      tokyonight = {
        # use nix-prefetch-git to get necessary info
        src = pkgs.fetchFromGitHub {
          owner = "folke";
          repo = "tokyonight.nvim";
          rev = "b262293ef481b0d1f7a14c708ea7ca649672e200";
          sha256 = "1cd8wxgicfm5f6g7lzqfhr1ip7cca5h11j190kx0w52h0kbf9k54";
        };
        file = "extras/sublime/tokyonight_night.tmTheme";
      };
    };
    extraPackages = with pkgs.bat-extras; [ batgrep batman prettybat ];
  };

  programs.fastfetch = {
    enable = true;
    settings = {
      modules = [
        "title"
        "separator"
        "os"
        {
          "type" = "host";
          "format" = "{/2}{-}{/}{2}{?3} {3}{?}";
        }
        "kernel"
        "uptime"
        {
          "type" = "battery";
          "format" = "{/4}{-}{/}{4}{?5} [{5}]{?}";
        }
        "break"
        "packages"
        "shell"
        "display"
        "terminal"
        "break"
        "cpu"
        {
          "type" = "gpu";
          "key" = "GPU";
        }
        "memory"
        "break"
        "colors"
      ];
    };
  };


  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}