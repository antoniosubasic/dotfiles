{
  programs.plasma.shortcuts = {
    services = {
      "Alacritty.desktop"._launch = "Ctrl+Alt+T";
      "org.kde.kalk.desktop"._launch = "Calculator";
    };
    kwin = {
      "Switch One Desktop Down" = "Meta+J,none,Switch One Desktop Down";
      "Switch One Desktop Up" = "Meta+K,none,Switch One Desktop Up";
      "Switch One Desktop to the Left" = "Meta+H,none,Switch One Desktop to the Left";
      "Switch One Desktop to the Right" = "Meta+L,none,Switch One Desktop to the Right";

      "Window One Desktop Down" = "Meta+Shift+J,none,Window One Desktop Down";
      "Window One Desktop Up" = "Meta+Shift+K,none,Window One Desktop Up";
      "Window One Desktop to the Left" = "Meta+Shift+H,none,Window One Desktop to the Left";
      "Window One Desktop to the Right" = "Meta+Shift+L,none,Window One Desktop to the Right";

      "Window Maximize" = "Meta+Up,none,Maximize Window";
    };
    ksmserver = {
      "Lock Session" = "Ctrl+Alt+L,none,Lock Session";
    };
  };
}
