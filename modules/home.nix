{ utilities, desktop, ... }:

{
  imports = [
    ./${desktop}/home.nix
  ] ++ utilities.importNixFiles ./home-configurations;
}
