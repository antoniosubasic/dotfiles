{
  utils,
  lib,
  pkgs,
  unstable,
  ...
}:

{
  imports = utils.importNixFiles ./programs;

  home.packages =
    with pkgs;
    lib.optionals (utils.hasTag "shell") [
      asciidoctor
      sl
      exiftool
      testdisk
    ]
    ++
      lib.optionals
        (utils.hasTags [
          "shell"
          "dev"
        ])
        [
          just
          gh
          tokei
        ]
    ++ lib.optionals (utils.hasTag "dev") [
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
      cargo
      rustc
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
    ++ lib.optionals (utils.hasTag "personal") [
      google-chrome
      tor-browser
      gimp
      banana-cursor
      libreoffice-still
    ];
}
