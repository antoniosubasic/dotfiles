{ pkgs, ... }:

{
  xdg.desktopEntries = {
    gmail-url-handler = {
      name = "Gmail URL Handler";
      exec = "${pkgs.xdg-utils}/bin/xdg-open \"https://mail.google.com/mail/?extsrc=mailto&url=%u\"";
      type = "Application";
      mimeType = [ "x-scheme-handler/mailto" ];
      terminal = false;
      startupNotify = false;
      noDisplay = true;
    };
  };
}
