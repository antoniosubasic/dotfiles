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
    (dotnetCorePackages.combinePackages [
      dotnet-sdk_8
      dotnet-sdk_9
    ])
    cargo
    rustc
    nodejs
    typescript
    swi-prolog
    
    # jdk with javafx support
    (pkgs.jdk23.override { enableJavaFX = true; })
    (pkgs.openjfx.override { withWebKit = true; })
    maven
  ];
}
