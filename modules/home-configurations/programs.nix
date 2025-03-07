{ utilities, pkgs, unstable, ... }:

{
  imports = utilities.importNixFiles ./programs;

  home.packages = with pkgs; [
    # CLI
    asciidoctor
    sl
    nixd
    nixfmt-rfc-style
    sqlite
    exiftool
    testdisk

    # Languages
    gcc
    (dotnetCorePackages.combinePackages [
      dotnet-sdk_8
      dotnet-sdk_9
    ])
    cargo
    rustc
    nodejs
    typescript
    swi-prolog
    (pkgs.jdk23.override { enableJavaFX = true; })
    (pkgs.openjfx.override { withWebKit = true; })
    maven

    # GUI
    google-chrome
    unstable.vscode
    dropbox
    keepassxc
    libreoffice-still
    jetbrains.idea-ultimate
    jetbrains.datagrip
  ];
}
