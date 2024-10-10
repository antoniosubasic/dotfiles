return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local config = require("nvim-treesitter.configs")
        config.setup({
            ensure_installed = {
                "vim",
                "vimdoc",
                "rust",
                "toml",
                "json",
                "bash",
                "regex",
                "comment",
                "python",
                "c_sharp",
                "java",
                "html",
                "css",
                "javascript",
                "typescript",
                "c",
                "lua",
                "markdown",
            },
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
        })
    end,
}
