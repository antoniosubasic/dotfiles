{ utilities, ... }:

{
  programs.texlive = {
    enable = utilities.hasTag "personal";
    extraPackages = tpkgs: { inherit (tpkgs) scheme-full; };
  };
}
