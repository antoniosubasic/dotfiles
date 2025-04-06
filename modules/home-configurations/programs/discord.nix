{
  utilities,
  lib,
  unstable,
  ...
}:

lib.optionalAttrs (utilities.hasTag "personal") {
  home.packages = [
    (unstable.discord.override { withVencord = true; })
  ];

  home.file.".config/Vencord/settings/settings.json".source = ./vencord-settings.json;
}
