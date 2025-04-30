{
  upkgs,
  lib,
  utilities,
  ...
}:

lib.optionalAttrs
  (utilities.hasTags [
    "gui"
    "personal"
  ])
  {
    home.packages = [
      (upkgs.discord.override { withVencord = true; })
    ];

    home.file.".config/Vencord/settings/settings.json".source = ./vencord-settings.json;
  }
