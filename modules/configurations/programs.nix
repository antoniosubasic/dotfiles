{
  pkgs,
  utils,
  ...
}:

{
  environment.systemPackages =
    with pkgs;
    lib.optionals (utils.hasTag "shell") [
      man
      curl
      wget
      unzip
      libnotify
      jq
      xsel
      ripgrep
    ]
    ++ lib.optionals (utils.hasTag "dev") [
      docker-compose
    ];

  services = {
    tailscale.enable = utils.hasTag "personal";
    plantuml-server = {
      enable = utils.hasTag "dev";
      listenPort = 9090;
    };
  };

  programs = {
    zsh.enable = utils.hasTag "shell";
    wireshark = {
      enable = utils.hasTag "dev";
      package = pkgs.wireshark;
    };
  };

  virtualisation = {
    docker.enable = utils.hasTag "dev";
    containerd.enable = utils.hasTag "dev";
  };
}
