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
      jq
    ]
    ++
      lib.optionals
        (utilities.hasTags [
          "shell"
          "personal"
        ])
        [
          xsel
          ripgrep
          libnotify
        ]
    ++ lib.optionals (utilities.hasTag "dev") [
      docker-compose
    ];

  virtualisation = {
    docker.enable = utilities.hasTag "dev";
    containerd.enable = utilities.hasTag "dev";
  };

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
      enable = utilities.hasTags [
        "gui"
        "dev"
      ];
      package = pkgs.wireshark;
    };
    gnome-disks.enable = utilities.hasTags [
      "gui"
      "personal"
    ];
  };
}
