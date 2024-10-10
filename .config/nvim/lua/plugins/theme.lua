return {
    "Mofiqul/vscode.nvim",
    name = "vscode",
    lazy = false,
    priority = 1000,
    config = function()
        vim.cmd.colorscheme("vscode") -- also see lualine.lua for statusline themes
    end,
}
