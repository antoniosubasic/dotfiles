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
    lib.optionals (utilities.hasTag "shell") [
      man
      curl
      wget
      unzip
      jq
      exiftool
      testdisk
      openssl
      openssl.dev
      pkg-config
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
      upkgs.cargo
      upkgs.rust-analyzer
      upkgs.rustc
      upkgs.clippy
      upkgs.rustfmt
      upkgs.trunk
      nodejs
      typescript
      swi-prolog
      (pkgs.jdk23.override { enableJavaFX = true; })
      (pkgs.openjfx.override { withWebKit = true; })
      maven
      python314
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
    firefox = {
      enable = utilities.hasTags [
        "gui"
        "personal"
      ];
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        DisablePocket = true;
        DisableFirefoxAccounts = true;
        DisableAccounts = true;
        DisableFirefoxScreenshots = true;
        DontCheckDefaultBrowser = true;
        DisplayBookmarksToolbar = "never";
        ExtensionSettings = {
          "*".installation_mode = "blocked";
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
          "jid1-MnnxcxisBPnSXQ@jetpack" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
            installation_mode = "force_installed";
          };
        };
        Preferences =
          let
            value-true = {
              Value = true;
              Status = "locked";
            };
            value-false = {
              Value = false;
              Status = value-true.Status;
            };
          in
          {
            "browser.contentblocking.category" = {
              Value = "strict";
              Status = "locked";
            };
            "browser.topsites.contile.enabled" = value-false;
            "extensions.screenshots.disabled" = value-true;
            "browser.newtabpage.activity-stream.feeds.topsites" = value-false;
            "browser.newtabpage.activity-stream.showSponsored" = value-false;
            "browser.newtabpage.activity-stream.system.showSponsored" = value-false;
            "browser.newtabpage.activity-stream.showSponsoredTopSites" = value-false;
            "browser.search.defaultenginename" = "DuckDuckGo";
            "browser.search.order.1" = "DuckDuckGo";
          };
      };
    };
  };
}
