return {
    'ccaglak/larago.nvim',
    dependencies = {
        "nvim-lua/plenary.nvim"
    },
    init = function()
        vim.keymap.set('n', '<leader>gb', ':GoBlade<CR>')
    end
}