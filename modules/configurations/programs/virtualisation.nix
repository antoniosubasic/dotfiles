{ utilities, ... }:

{
  virtualisation = rec {
    docker.enable = utilities.hasTag "dev";
    containerd.enable = docker.enable;
  };
}
