return {
    {
        "ray-x/go.nvim",
        dependencies = {  -- paket opsional
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("go").setup()
        end,
        event = {"CmdlineEnter"},
        ft = {"go", "gomod"},
        build = ':lua require("go.install").update_all_sync()' -- jika Anda perlu menginstal/memperbarui semua biner
    }
}
