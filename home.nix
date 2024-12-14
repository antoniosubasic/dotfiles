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
      fastfetch

      # applications
      google-chrome
      dropbox
      vscode
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
      (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];

    file = {
      ".config/nvim".source = ./dotfiles/nvim;
      ".config/bash".source = ./dotfiles/bash;
    };
  };

  fonts.fontconfig.enable = true;

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

  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
      window = {
        dimensions = { columns = 125; lines = 30; };
        padding = { x = 10; y = 10; };
        decorations = "full";
        opacity = 0.99;
      };
      scrolling.history = 10000;
      selection.save_to_clipboard = true;
      font = {
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Italic";
        };
        bold_italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold Italic";
        };
      };
      keyboard.bindings = [
        { key = "N"; mods = "Control"; action = "SpawnNewInstance"; }
      ];
      colors = {
        primary = {
          background = "#1a1b26";
          foreground = "#a9b1d6";
        };
        normal = {
          black = "#32344a";
          red = "#f7768e";
          green = "#9ece6a";
          yellow = "#e0af68";
          blue = "#7aa2f7";
          magenta = "#ad8ee6";
          cyan = "#449dab";
          white = "#787c99";
        };
        bright = {
          black = "#444b6a";
          red = "#ff7a93";
          green = "#b9f27c";
          yellow = "#ff9e64";
          blue = "#7da6ff";
          magenta = "#bb9af7";
          cyan = "#0db9d7";
          white = "#acb0d0";
        };
      };
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = "[ -f ~/.config/bash/init.sh ] && source ~/.config/bash/init.sh";
    historySize = 1000;
    historyFileSize = 1000;
    historyControl = [
      "ignorespace"
      "ignoredups"
      "ignoreboth"
      "erasedups"
    ];
    historyIgnore = [
      "ls"
      "ll"
      "la"
      "l"
      "cd"
      "cd -"
      "pwd"
      "clear"
      "exit"
      "history"
      ":q"
    ];
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.bat = {
    enable = true;
    themes = {
      tokyonight = {
        # use nix-prefetch-git to get necessary info
        src = pkgs.fetchFromGitHub {
          owner = "folke";
          repo = "tokyonight.nvim";
          rev = "b262293ef481b0d1f7a14c708ea7ca649672e200";
          sha256 = "1cd8wxgicfm5f6g7lzqfhr1ip7cca5h11j190kx0w52h0kbf9k54";
        };
        file = "extras/sublime/tokyonight_night.tmTheme";
      };
    };
    extraPackages = with pkgs.bat-extras; [ batgrep batman prettybat ];
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