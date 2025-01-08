{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (discord.override { withVencord = true; })
  ];

  home.file.".config/Vencord/settings/settings.json".source = ./vencord-settings.json;
}
