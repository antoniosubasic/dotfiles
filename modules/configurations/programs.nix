{
  pkgs,
  upkgs,
  lib,
  utilities,
  ...
}:

{
  environment.systemPackages =
    with pkgs;
    [
      man
      curl
      wget
      unzip
      openssl
      openssl.dev
      pkg-config
    ]
    ++ lib.optionals (utilities.hasTag "shell") [
      jq
      exiftool
      testdisk
      libnotify
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
          nix-search-cli
          xh
          hyperfine
          presenterm
        ]
    ++ lib.optionals (utilities.hasTag "dev") [
      nixd
      nixfmt-rfc-style
      docker-compose
      sqlite
      gcc
      lld
      (dotnetCorePackages.combinePackages [
        dotnet-sdk_8
        dotnet-sdk_9
        dotnet-sdk_10
      ])
      upkgs.cargo
      upkgs.rust-analyzer
      upkgs.rustc
      upkgs.clippy
      upkgs.rustfmt
      upkgs.trunk
      nodejs
      typescript
      swi-prolog
      (pkgs.jdk21.override { enableJavaFX = true; })
      (pkgs.openjfx21.override { withWebKit = true; })
      maven
      python314
      kondo
    ]
    ++
      lib.optionals
        (utilities.hasTags [
          "shell"
          "dev"
        ])
        [
          just
          mask
          tokei
          upkgs.act
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
          signal-desktop
          spotify
          bibata-cursors
        ];

  virtualisation.docker.enable = utilities.hasTag "dev";

  services = rec {
    tailscale = {
      enable = utilities.hasTag "personal";
      package = upkgs.tailscale;
      extraUpFlags = [ "--operator=$USER" ];
    };
    plantuml-server = {
      enable = utilities.hasTag "dev";
      listenPort = 9090;
    };
    ollama =
      {
        enable = utilities.hasTag "ai";
        package = upkgs.ollama;
      }
      // lib.optionalAttrs (utilities.hasTag "nvidia") {
        acceleration = "cuda";
      };
    open-webui = {
      enable = ollama.enable && utilities.hasTag "gui";
      package = upkgs.open-webui;
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
