{ lib, utilities, ... }:

lib.optionalAttrs
  (utilities.hasTags [
    "gui"
    "personal"
  ])
  {
    services.dropbox.enable = true;
  }
