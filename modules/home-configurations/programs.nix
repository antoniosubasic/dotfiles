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
    lib.optionals (utilities.hasTag "shell") [
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
        ]
    ++ lib.optionals (utilities.hasTag "dev") [
      # language server
      nixd
      nixfmt-rfc-style

      # tools
      unstable.act

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
      trunk
      nodejs
      typescript
      swi-prolog
      (pkgs.jdk23.override { enableJavaFX = true; })
      (pkgs.openjfx.override { withWebKit = true; })
      maven

      # editor
      unstable.vscode
      jetbrains.idea-ultimate
      jetbrains.datagrip
    ]
    ++ lib.optionals (utilities.hasTag "personal") [
      google-chrome
      tor-browser
      gimp
      banana-cursor
      libreoffice-still
    ];
}
