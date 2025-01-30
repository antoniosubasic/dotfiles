{ utilities, ... }:

{
  imports = utilities.importNixFiles ./home-configurations;
  programs.plasma.enable = true;
}
