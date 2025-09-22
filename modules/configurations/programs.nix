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
        hyperfine
        aoc-runtime
        trashy
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
        upkgs.cargo
        upkgs.rust-analyzer
        upkgs.rustc
        upkgs.clippy
        upkgs.rustfmt
        upkgs.trunk
        nodejs
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
      packages = with pkgs; [
        just
        mask
        tokei
        upkgs.act
      ];
    }
    {
      tags = [
        "dev"
        "gui"
      ];
      packages = with pkgs; [
        jetbrains-toolbox
        upkgs.burpsuite
      ];
    }
    {
      tags = [
        "personal"
        "gui"
      ];
      packages = with pkgs; [
        google-chrome
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
