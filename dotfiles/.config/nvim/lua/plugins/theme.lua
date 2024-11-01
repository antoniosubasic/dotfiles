return {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        vim.cmd.colorscheme("tokyonight-night") -- also see lualine.lua for statusline themes
    end,
}
