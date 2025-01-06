{ utilities, desktop, ... }:

{
  imports = [
    ./${desktop}/configuration.nix
  ] ++ utilities.importNixFiles ./configurations;
}
