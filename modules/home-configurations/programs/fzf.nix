{ utilities, ... }:

{
  programs.fzf = {
    enable = utilities.hasTag "shell";
    enableZshIntegration = true;
    defaultCommand = "fd --type f --follow";
    defaultOptions = [ "--reverse" ];
  };
}
