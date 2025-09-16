{
  pkgs,
  upkgs,
  lib,
  utilities,
  ...
}:

{
  imports = utilities.importNixFiles ./programs;

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
      ffmpeg
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
          xh
          hyperfine
          aoc-runtime
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
      ])
      upkgs.cargo
      upkgs.rust-analyzer
      upkgs.rustc
      upkgs.clippy
      upkgs.rustfmt
      upkgs.trunk
      nodejs
      typescript
      (pkgs.jdk21.override { enableJavaFX = true; })
      (pkgs.openjfx21.override { withWebKit = true; })
      maven
      python314
      go
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
          jetbrains.datagrip
          jetbrains-toolbox
          upkgs.burpsuite
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
          libreoffice-still
          signal-desktop
          spotify
          vlc
        ];
}
