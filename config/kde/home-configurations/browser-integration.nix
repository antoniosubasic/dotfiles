{ pkgs, ... }:

{
  home.file.".config/google-chrome/NativeMessagingHosts/org.kde.plasma.browser_integration.json".source =
    "${pkgs.kdePackages.plasma-browser-integration}/etc/chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json";
}
