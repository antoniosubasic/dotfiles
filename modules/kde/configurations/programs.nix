{
  pkgs,
  lib,
  utilities,
  ...
}:

{
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    konsole
    elisa
    khelpcenter
  ];

  programs.kdeconnect.enable = utilities.hasTag "personal";

  environment.systemPackages = lib.optionals (utilities.hasTag "personal") (
    with pkgs.kdePackages;
    [
      kalk
      kdenlive
      (pkgs.karp)
      kompare
    ]
  );
}
