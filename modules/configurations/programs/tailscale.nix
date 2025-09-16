{ upkgs, utilities, ... }:

{
  services.tailscale = {
    enable = utilities.hasTag "personal";
    package = upkgs.tailscale;
    extraUpFlags = [ "--operator=$USER" ];
    useRoutingFeatures = if utilities.hasTag "personal" then "client" else "none";
  };
}
