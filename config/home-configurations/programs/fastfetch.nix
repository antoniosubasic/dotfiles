{ utilities, ... }:

{
  programs.fastfetch.enable = utilities.hasTag "shell";
}
