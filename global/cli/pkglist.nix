{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    man
    curl
    wget
    unzip
    docker-compose
    jq
    xsel
    ripgrep
    asciidoctor
    testdisk
    sl
    eza
    libnotify
    
    gcc
    dotnet-sdk
    cargo
    rustc
    nodejs
    typescript
    temurin-bin
    maven
    
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
}
