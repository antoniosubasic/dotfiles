{ pkgs, utilities, ... }:

{
  programs = rec {
    steam = {
      enable = utilities.hasTags [
        "gui"
        "gaming"
      ];
      gamescopeSession.enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
    gamemode.enable = steam.enable;
  };
}
