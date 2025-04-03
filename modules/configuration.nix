{ utils, desktop, ... }:

{
  imports = [
    ./${desktop}/configuration.nix
  ] ++ utils.importNixFiles ./configurations;
}
