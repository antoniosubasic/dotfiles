{ utilities, pkgs, unstable, ... }:

{
  imports = utilities.importNixFiles ./programs;

  home.packages = with pkgs; [
    jq
    xsel
    ripgrep
    asciidoctor
    sl
    eza
    nixd
    nixfmt-rfc-style

    unstable.vscode
    dropbox
    libreoffice-still
    keepassxc
    jetbrains.idea-ultimate
    jetbrains.datagrip

    gcc
    dotnet-sdk
    cargo
    rustc
    nodejs
    typescript
    temurin-bin
    maven
  ];
}
