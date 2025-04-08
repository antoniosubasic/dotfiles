{ utilities, ... }:

{
  programs.eza = {
    enable = utilities.hasTag "shell";
    colors = "always";
    git = true;
    icons = "always";
    extraOptions = [ "-U" "--time-style=+\"%d.%m.%Y %H:%M:%S\"" ];
  };
}
