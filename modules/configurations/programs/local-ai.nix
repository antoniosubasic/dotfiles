{
  upkgs,
  lib,
  utilities,
  ...
}:

{
  services = rec {
    ollama = {
      enable = utilities.hasTag "ai";
      package = upkgs.ollama;
    }
    // lib.optionalAttrs (utilities.hasTag "nvidia") {
      acceleration = "cuda";
    };
    open-webui = {
      enable = ollama.enable && utilities.hasTag "gui";
      package = upkgs.open-webui;
      environment = {
        WEBUI_AUTH = "False";
        DEFAULT_USER_ROLE = "admin";
        DO_NOT_TRACK = "True";
        SCARF_NO_ANALYTICS = "True";
      };
      port = 8888;
    };
  };
}
