{ pkgs, ... }:

{
  programs.neovim = {
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

      vim.opt.runtimepath:append(vim.fn.stdpath('data') .. '/parser')
      require('nvim-treesitter.configs').setup({
        parser_install_dir = vim.fn.stdpath('data') .. '/parser',
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

  home.file.".local/share/nvim/parser" = {
    recursive = true;
    enable = true;
    source = pkgs.runCommandNoCC "treesitter-parser-dir" { } ''
      mkdir -p $out
      chmod 755 $out
    '';
  };
}
