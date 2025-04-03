{
  pkgs,
  tags,
  utils,
  ...
}:

{
  environment.systemPackages =
    with pkgs;
    lib.mkIf (utils.hasTag tags "shell") [
      man
      curl
      wget
      unzip
      libnotify
      jq
      xsel
      ripgrep
    ]
    ++ lib.mkIf (utils.hasTag tags "dev") [
      docker-compose
    ];

  services = {
    tailscale.enable = utils.hasTag tags "personal";
    plantuml-server = {
      enable = utils.hasTag tags "dev";
      listenPort = 9090;
    };
  };

  programs = {
    zsh.enable = utils.hasTag tags "shell";
    wireshark = {
      enable = utils.hasTag tags "dev";
      package = pkgs.wireshark;
    };
  };

  virtualisation = {
    docker.enable = utils.hasTag tags "dev";
    containerd.enable = utils.hasTag tags "dev";
  };
}
