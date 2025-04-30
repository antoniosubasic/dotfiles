{
  osConfig,
  lib,
  utilities,
  username,
  ...
}:

{
  imports =
    utilities.importNixFiles ./home-configurations
    ++ lib.optionals (utilities.hasTag "kde") [
      ./kde/home.nix
    ];

  home = {
    username = osConfig.users.users.${username}.name;
    homeDirectory = osConfig.users.users.${username}.home;
  };
}
