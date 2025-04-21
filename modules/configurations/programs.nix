{
  pkgs,
  unstable,
  utilities,
  ...
}:

{
  environment.systemPackages =
    with pkgs;
    lib.optionals (utilities.hasTag "shell") [
      man
      curl
      wget
      unzip
      libnotify
      jq
      xsel
      ripgrep
    ]
    ++ lib.optionals (utilities.hasTag "dev") [
      docker-compose
    ];

  services = {
    tailscale = {
      enable = utilities.hasTag "personal";
      package = unstable.tailscale;
      extraUpFlags = [ "--operator=$USER" ];
    };
    plantuml-server = {
      enable = utilities.hasTag "dev";
      listenPort = 9090;
    };
  };

  programs = {
    zsh.enable = utilities.hasTag "shell";
    wireshark = {
      enable = utilities.hasTag "dev";
      package = pkgs.wireshark;
    };
    gnome-disks.enable = utilities.hasTag "personal";
  };

  virtualisation = {
    docker.enable = utilities.hasTag "dev";
    containerd.enable = utilities.hasTag "dev";
  };
}
