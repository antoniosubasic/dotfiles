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
    just
    gh
    tokei

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
    tor-browser
    unstable.vscode
    dropbox
    gimp
    libreoffice-still
    jetbrains.idea-ultimate
    jetbrains.datagrip
    wireshark
  ];
}
