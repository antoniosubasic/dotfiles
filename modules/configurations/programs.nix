{
  pkgs,
  upkgs,
  lib,
  utilities,
  ...
}:

let
  taggedPackages = [
    {
      packages = with pkgs; [
        man
        curl
        wget
        unzip
        openssl
        openssl.dev
        pkg-config
      ];
    }
    {
      tags = [ "shell" ];
      packages = with pkgs; [
        jq
        exiftool
        testdisk
        libnotify
        ffmpeg
      ];
    }
    {
      tags = [
        "shell"
        "personal"
      ];
      packages = with pkgs; [
        wl-clipboard
        asciidoctor
        sl
        xh
        aoc-runtime
        asciinema
      ];
    }
    {
      tags = [ "dev" ];
      packages = with pkgs; [
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
        cargo
        rust-analyzer
        rustc
        clippy
        rustfmt
        trunk
        nodejs_latest
        typescript
        jdk
        maven
        python314
        go
      ];
    }
    {
      tags = [
        "dev"
        "shell"
      ];
      packages = with upkgs; [
        just
        tokei
        act
      ];
    }
    {
      tags = [
        "dev"
        "gui"
      ];
      packages = with upkgs; [
        jetbrains-toolbox
        burpsuite
      ];
    }
    {
      tags = [
        "personal"
        "gui"
      ];
      packages = with pkgs; [
        google-chrome
        ungoogled-chromium
        tor-browser
        gimp
        libreoffice-still
        signal-desktop
        spotify
        vlc
      ];
    }
    {
      tags = [ "nvidia" ];
      packages = with pkgs; [
        vulkan-loader
        vulkan-tools
      ];
    }
  ];
in
{
  imports = utilities.importNixFiles ./programs;

  environment.systemPackages = lib.flatten (
    map (
      entry:
      if entry ? tags then
        if utilities.hasTags entry.tags then entry.packages else [ ]
      else
        entry.packages
    ) taggedPackages
  );
}
