{ utilities, ... }:

{
  virtualisation = rec {
    docker.enable = utilities.hasTag "dev";
    containerd.enable = docker.enable;

    virtualbox.host = rec {
      enable = utilities.hasTags [
        "personal"
        "gui"
      ];
      enableExtensionPack = enable;
    };
  };
}
