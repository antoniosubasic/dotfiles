{ username }: { config, pkgs, lib, ... }:

{
  home = {
    username = username;
    homeDirectory = "/home/${username}";

    packages = with pkgs; [
      # packages
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
      fzf
      eza

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
  };

  fonts.fontconfig.enable = true;

  programs = {
    git = {
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

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      plugins = with pkgs.vimPlugins; [
        # core
        plenary-nvim
        nvim-web-devicons

        # UI
        alpha-nvim
        lualine-nvim
        tokyonight-nvim

        # functionality
        telescope-nvim
        telescope-ui-select-nvim
        nvim-treesitter
      ];

      extraLuaConfig = ''
        vim.g.mapleader = " "
        vim.g.maplocalleader = "\\"

        vim.opt.expandtab = true
        vim.opt.tabstop = 4
        vim.opt.softtabstop = 4
        vim.opt.shiftwidth = 4
        vim.opt.number = true
        vim.opt.relativenumber = true

        vim.cmd.colorscheme("tokyonight-night")

        require('nvim-treesitter.configs').setup({
          ensure_installed = {
            "bash", "c", "c_sharp", "cpp", "css", "dockerfile",
            "go", "html", "java", "javascript", "json", "lua",
            "markdown", "python", "regex", "rust", "sql",
            "toml", "typescript", "vue", "xml", "yaml"
          },
          auto_install = true,
          highlight = { enable = true },
          indent = { enable = true },
        })

        local telescope = require('telescope')
        telescope.setup({
          pickers = {
            find_files = { hidden = true },
          },
          extensions = {
            ['ui-select'] = {
              require('telescope.themes').get_dropdown({})
            }
          }
        })
        telescope.load_extension('ui-select')

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<C-p>', builtin.find_files, {})
        vim.keymap.set('n', '<leader>lg', builtin.live_grep, {})

        require('lualine').setup({
          options = {
            theme = 'tokyonight-night'
          }
        })

        local alpha = require('alpha')
        local dashboard = require('alpha.themes.startify')

        dashboard.section.header.val = {
          [[                                                                        ]],
          [[           ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗           ]],
          [[           ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║           ]],
          [[           ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║           ]],
          [[           ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║           ]],
          [[           ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║           ]],
          [[           ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝           ]],
        }

        alpha.setup(dashboard.opts)
      '';
    };

    alacritty = {
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

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      autocd = true;

      shellAliases = {
        ls = "eza --git --icons --time-style=+\"%d.%m.%Y %H:%M:%S\" --color=always";
        ll = "ls -al";
        tree = "ls -T";

        grep = "rg";
        adoc = "asciidoctor";
        shutdown = "shutdown -h now";
        ":q" = "exit";
        neofetch = "fastfetch";

        copy = "xsel --input --clipboard";
        paste = "xsel --output --clipboard";

        ".." = "cd ..";
        "2.." = "cd ../..";
        "3.." = "cd ../../..";
        "4.." = "cd ../../../..";
        "5.." = "cd ../../../../..";
      };

      history = {
        size = 500;
        save = 500;
        append = true;
        ignoreSpace = true;
        ignoreDups = true;
        ignoreAllDups = true;
        expireDuplicatesFirst = true;
        share = true;
        extended = true;
        ignorePatterns = [
          "history *"
          "pwd"
          "exit"
          ":q"
          "clear"
        ];
      };

      initExtra = ''
        autoload -Uz compinit
        autoload -Uz vcs_info
        compinit

        precmd() { vcs_info }

        zstyle ':vcs_info:*' enable git
        zstyle ':vcs_info:*' check-for-changes true
        zstyle ':vcs_info:git:*' formats ' %F{yellow}(%b)%f'
        zstyle ':vcs_info:git:*' unstagedstr '*'
        zstyle ':vcs_info:git:*' stagedstr '+'

        setopt PROMPT_SUBST
        PROMPT='%F{blue}%~%f''${vcs_info_msg_0_}%(?.%F{green}.%F{red}) ❯%f '

        bindkey -e
      '';

      plugins = [
        {
          name = "fzf-tab";
          src = pkgs.fetchFromGitHub {
            owner = "Aloxaf";
            repo = "fzf-tab";
            rev = "master";
            sha256 = "1brljd9744wg8p9v3q39kdys33jb03d27pd0apbg1cz0a2r1wqqi";
          };
        }
        {
          name = "zsh-fzf-history-search";
          src = pkgs.fetchFromGitHub {
            owner = "joshskidmore";
            repo = "zsh-fzf-history-search";
            rev = "master";
            sha256 = "1dm1asa4ff5r42nadmj0s6hgyk1ljrckw7val8fz2n0892b8h2mm";
          };
        }
      ];
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    bat = {
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

    fastfetch = {
      enable = true;
      settings = {
        modules = [
          "title"
          "separator"
          "os"
          {
            "type" = "host";
            "format" = "{/2}{-}{/}{2}{?3} {3}{?}";
          }
          "kernel"
          "uptime"
          {
            "type" = "battery";
            "format" = "{/4}{-}{/}{4}{?5} [{5}]{?}";
          }
          "break"
          "packages"
          "shell"
          "display"
          "terminal"
          "break"
          "cpu"
          {
            "type" = "gpu";
            "key" = "GPU";
          }
          "memory"
          "break"
          "colors"
        ];
      };
    };
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