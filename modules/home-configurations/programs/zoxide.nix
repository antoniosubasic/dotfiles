{ utils, ... }:

{
  programs.zoxide = {
    enable = utils.hasTag "shell";
    enableZshIntegration = true;
    options = [ "--cmd cd" ];
  };
}
