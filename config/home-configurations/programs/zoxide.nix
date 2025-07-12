{ config, utilities, ... }:

{
  programs.zoxide = {
    enable = utilities.hasTag "shell";
    enableZshIntegration = config.programs.zsh.enable;
    options = [ "--cmd cd" ];
  };
}
