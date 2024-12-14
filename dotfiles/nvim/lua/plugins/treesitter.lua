return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local config = require("nvim-treesitter.configs")
        config.setup({
            ensure_installed = {
                "bash",
                "c",
                "c_sharp",
                "cpp",
                "css",
                "dockerfile",
                "go",
                "html",
                "java",
                "javascript",
                "json",
                "lua",
                "markdown",
                "python",
                "regex",
                "rust",
                "sql",
                "toml",
                "typescript",
                "vue",
                "xml",
                "yaml",
            },
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
        })
    end,
}
