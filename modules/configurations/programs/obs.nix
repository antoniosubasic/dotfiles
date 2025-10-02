{
  pkgs,
  lib,
  utilities,
  ...
}:

{
  programs.obs-studio = rec {
    enable = utilities.hasTags [
      "personal"
      "gui"
    ];
    enableVirtualCamera = enable;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-gstreamer
      obs-vkcapture
    ];
  }
  // lib.optionalAttrs (utilities.hasTag "nvidia") {
    package = pkgs.obs-studio.override {
      cudaSupport = true;
    };
  };
}
