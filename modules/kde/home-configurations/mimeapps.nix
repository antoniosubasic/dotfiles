let
  pdf = "org.kde.okular.desktop";
  image = "org.kde.gwenview.desktop";
  plaintext = "org.kde.kate.desktop";
  browser = "google-chrome.desktop";
  geolocation = "google-maps-geo-handler.desktop";
in
{
  programs.plasma.configFile."mimeapps.list" = {
    "Added Associations" = {
      "application/pdf" = pdf;
      "image/avif" = image;
      "image/bmp" = image;
      "image/heif" = image;
      "image/jpeg" = image;
      "image/png" = image;
      "image/svg+xml" = image;
      "image/webp" = image;
      "image/x-icns" = image;
      "text/plain" = plaintext;
      "x-scheme-handler/geo" = geolocation;
    };
    "Default Applications" = {
      "application/pdf" = pdf;
      "image/avif" = image;
      "image/bmp" = image;
      "image/heif" = image;
      "image/jpeg" = image;
      "image/png" = image;
      "image/svg+xml" = image;
      "image/webp" = image;
      "image/x-icns" = image;
      "text/html" = browser;
      "text/plain" = plaintext;
      "x-scheme-handler/geo" = geolocation;
      "x-scheme-handler/http" = browser;
      "x-scheme-handler/https" = browser;
      "x-scheme-handler/mailto" = browser;
    };
  };
}
