{
  utils,
  lib,
  unstable,
  ...
}:

lib.optionalAttrs (utils.hasTag "personal") {
  home.packages = [
    (unstable.discord.override { withVencord = true; })
  ];

  home.file.".config/Vencord/settings/settings.json".source = ./vencord-settings.json;
}
