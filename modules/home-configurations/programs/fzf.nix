{ utils, ... }:

{
  programs.fzf = {
    enable = utils.hasTag "shell";
    enableZshIntegration = true;
    defaultCommand = "fd --type f --follow";
    defaultOptions = [ "--reverse" ];
  };
}
