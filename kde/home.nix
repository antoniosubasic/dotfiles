{ config, pkgs, lib, ... }:

{
  home = {
    packages = with pkgs; [
      kdePackages.kconfig
      kdePackages.kalk
    ];

    file = {
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
      ".config/kcminputrc".text = ''
        [Libinput]
        NaturalScroll=true
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

        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "kglobalshortcutsrc" --group "ksmserver" --key "Lock Session" "Ctrl+Alt+L,Meta+L\tScreensaver,Lock Session"

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
        
        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "kwinrc" --group "Plugins" --key "shakecursorEnabled" "false"
        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "kwinrc" --group "org.kde.kdecoration2" --key "ButtonsOnLeft" "M"
      '';
    };
  };
}