return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "ast_grep",
                    "bashls",
                    "omnisharp",
                    "dockerls",
                    "biome",
                    "grammarly",
                    "harper_ls",
                    "rust_analyzer",
                },
                auto_install = true,
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup({ capabilities = capabilities })
            lspconfig.ast_grep.setup({ capabilities = capabilities })
            lspconfig.bashls.setup({ capabilities = capabilities })
            lspconfig.omnisharp.setup({ capabilities = capabilities })
            lspconfig.dockerls.setup({ capabilities = capabilities })
            lspconfig.biome.setup({ capabilities = capabilities })
            lspconfig.grammarly.setup({ capabilities = capabilities })
            lspconfig.harper_ls.setup({ capabilities = capabilities })
            lspconfig.rust_analyzer.setup({ capabilities = capabilities })

            vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
            vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
            vim.keymap.set({ "n" }, "<leader>ca", vim.lsp.buf.code_action, {})
        end,
    },
}
