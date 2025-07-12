{ config, utilities, ... }:

{
  programs.fzf = {
    enable = utilities.hasTag "shell";
    enableZshIntegration = config.programs.zsh.enable;
    defaultCommand = "fd --type f --follow";
    defaultOptions = [ "--reverse" ];
  };
}
