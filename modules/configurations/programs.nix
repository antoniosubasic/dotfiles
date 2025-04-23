{
  lib,
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
      exiftool
      testdisk
    ]
    ++
      lib.optionals
        (utilities.hasTags [
          "shell"
          "personal"
        ])
        [
          wl-clipboard
          asciidoctor
          sl
        ]
    ++ lib.optionals (utilities.hasTag "dev") [
      nixd
      nixfmt-rfc-style
      docker-compose
      sqlite
      gcc
      (dotnetCorePackages.combinePackages [
        dotnet-sdk_8
        dotnet-sdk_9
        dotnet-sdk_10
      ])
      rustup
      unstable.trunk
      nodejs
      typescript
      swi-prolog
      (pkgs.jdk23.override { enableJavaFX = true; })
      (pkgs.openjfx.override { withWebKit = true; })
      maven
    ]
    ++
      lib.optionals
        (utilities.hasTags [
          "shell"
          "dev"
        ])
        [
          just
          tokei
          unstable.act
        ]
    ++
      lib.optionals
        (utilities.hasTags [
          "gui"
          "dev"
        ])
        [
          jetbrains.idea-ultimate
          jetbrains.datagrip
        ]
    ++
      lib.optionals
        (utilities.hasTags [
          "gui"
          "personal"
        ])
        [
          google-chrome
          tor-browser
          gimp
          banana-cursor
          libreoffice-still
          vlc
        ];

  virtualisation = {
    docker.enable = utilities.hasTag "dev";
    containerd.enable = utilities.hasTag "dev";
  };

  services = rec {
    tailscale = {
      enable = utilities.hasTag "personal";
      package = unstable.tailscale;
      extraUpFlags = [ "--operator=$USER" ];
    };
    plantuml-server = {
      enable = utilities.hasTag "dev";
      listenPort = 9090;
    };
    ollama =
      {
        enable = utilities.hasTag "ai";
        package = unstable.ollama;
      }
      // lib.optionalAttrs (utilities.hasTag "nvidia") {
        acceleration = "cuda";
      };
    open-webui = {
      enable = ollama.enable && utilities.hasTag "gui";
      package = unstable.open-webui;
      environment = {
        WEBUI_AUTH = "False";
        DEFAULT_USER_ROLE = "admin";
        DO_NOT_TRACK = "True";
        SCARF_NO_ANALYTICS = "True";
      };
      port = 8888;
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
