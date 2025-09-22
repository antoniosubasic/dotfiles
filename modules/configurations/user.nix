{
  config,
  pkgs,
  lib,
  username,
  ...
}:

{
  users.users.${username} = {
    isNormalUser = true;
    name = username;
    home = "/home/${username}";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
    ]
    ++ lib.optionals (config.virtualisation.docker.enable) [
      "docker"
    ]
    ++ lib.optionals (config.programs.wireshark.enable) [
      "wireshark"
    ];
  };
}
