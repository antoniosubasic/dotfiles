{
  programs.plasma.shortcuts = {
    "services/Alacritty.desktop"."_launch" = "Ctrl+Alt+T";
    "services/org.kde.kalk.desktop"."_launch" = "Calculator";

    "kwin" = {
      "Switch One Desktop Down" = "Meta+J";
      "Switch One Desktop Up" = "Meta+K";
      "Switch One Desktop to the Left" = "Meta+H";
      "Switch One Desktop to the Right" = "Meta+L";

      "Window One Desktop Down" = "Meta+Alt+J";
      "Window One Desktop Up" = "Meta+Alt+K";
      "Window One Desktop to the Left" = "Meta+Alt+H";
      "Window One Desktop to the Right" = "Meta+Alt+L";

      "Window to Next Screen" = "Meta+Shift+L";
      "Window to Previous Screen" = "Meta+Shift+H";

      "Window Maximize" = "Meta+M";
    };

    "ksmserver" = {
      "Lock Session" = "Meta+Ctrl+Shift+L";
      "Reboot Without Confirmation" = "Meta+Ctrl+Shift+R";
      "Halt Without Confirmation" = "Meta+Ctrl+Shift+S";
    };

    "org_kde_powerdevil" = {
      "Hibernate" = "Meta+Ctrl+Shift+H";
    };
  };
}
