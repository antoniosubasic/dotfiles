{ config, pkgs, ... }:

{
  home = {
    username = "antonio";
    homeDirectory = "/home/antonio";

    packages = with pkgs; [
      # packages
      man
      curl
      wget
      git
      unzip
      jq
      xsel
      ripgrep
      asciidoctor
      testdisk
      sl
      fzf
      eza
      bat
      fastfetch

      # applications
      google-chrome
      dropbox
      vscode
      alacritty
      jetbrains.idea-ultimate
      jetbrains.datagrip
      libreoffice-still

      # languages
      gcc
      dotnet-sdk
      cargo
      rustc
      nodejs_23
      typescript
      temurin-bin
      maven

      # fonts
      jetbrains-mono
    ];
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
  };


  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}