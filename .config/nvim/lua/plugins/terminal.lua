return {
    "voldikss/vim-floaterm",
    config = function()
        vim.keymap.set("n", "<leader>ö", ":FloatermToggle<CR>", {})
    end,
}
