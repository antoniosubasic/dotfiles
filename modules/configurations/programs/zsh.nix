{ utilities, ... }:

{
  programs.zsh.enable = utilities.hasTag "shell";
}
