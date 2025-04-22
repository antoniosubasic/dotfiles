{
  utilities,
  lib,
  pkgs,
  unstable,
  ...
}:

{
  imports = utilities.importNixFiles ./programs;

  home.packages =
    with pkgs;
    lib.optionals
      (utilities.hasTags [
        "shell"
        "personal"
      ])
      [
        asciidoctor
        sl
        exiftool
        testdisk
      ]
    ++
      lib.optionals
        (utilities.hasTags [
          "shell"
          "dev"
        ])
        [
          just
          gh
          tokei
          unstable.act
        ]
    ++ lib.optionals (utilities.hasTag "dev") [
      # language server
      nixd
      nixfmt-rfc-style

      # database
      sqlite

      # languages
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
          "gui"
          "dev"
        ])
        [
          unstable.vscode
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
}
