{ utils, ... }:

{
  programs.eza = {
    enable = utils.hasTag "shell";
    colors = "always";
    git = true;
    icons = "always";
    extraOptions = "--time-style=+\"%d.%m.%Y %H:%M:%S\"";
  };
}
