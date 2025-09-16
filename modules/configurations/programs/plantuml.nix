{ utilities, ... }:

{
  services.plantuml-server = {
    enable = utilities.hasTag "dev";
    listenPort = 9090;
  };
}
