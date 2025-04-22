{
  lib,
  pkgs,
  utilities,
  ...
}:

let
  dropbox = pkgs.dropbox;
in
lib.optionalAttrs
  (utilities.hasTags [
    "gui"
    "personal"
  ])
  {
    home.packages = [ dropbox ];

    systemd.user.services.dropbox = {
      Unit = {
        Description = "Dropbox";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${dropbox}/bin/dropbox start -i";
        Restart = "on-failure";
        Type = "exec";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  }
