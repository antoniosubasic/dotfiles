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
      discord
      keepassxc

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

    file = {
      ".config/nvim".source = ./dotfiles/nvim;
    };
  };

  programs.git = {
    enable = true;
    userName = "Antonio Subašić";
    userEmail = "antonio.subasic.public@gmail.com";
    aliases = {
      cm = "commit -m";
      cp = "!f() { git clone git@github.com:$(git config user.github)/$1.git \${2:-$1}; }; f";
      transpose-ssh = "!f() { git remote set-url origin $(git remote get-url origin | sed 's|https://github.com/|git@github.com:|'); }; f";
      transpose-https = "!f() { git remote set-url origin $(git remote get-url origin | sed 's|git@github.com:|https://github.com/|'); }; f";
      tree = "log --graph --oneline --decorate --all";
      url = "!f() { git remote get-url origin | sed 's|git@github.com:|https://github.com/|'; }; f";
    };
    extraConfig = {
      user.github = "antoniosubasic";
      help.autocorrect = 10;
      url."git@github.com".insteadOf = "gh:";
      diff.algorithm = "histogram";
      status.submoduleSummary = true;
      core = { autocrlf = false; editor = "nvim"; };
      log.date = "iso";
      pull.ff = "only";
      push.autoSetupRemote = true;
      transfer.fsckobjects = true;
      fetch.fsckobjects = true;
      receive.fsckObjects = true;
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
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