{ utilities, ... }:

{
  programs.zoxide = {
    enable = utilities.hasTag "shell";
    enableZshIntegration = true;
    options = [ "--cmd cd" ];
  };
}
