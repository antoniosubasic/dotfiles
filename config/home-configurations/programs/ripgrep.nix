{ utilities, ... }:

{
  programs.ripgrep.enable = utilities.hasTag "shell";
}
