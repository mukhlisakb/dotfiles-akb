return {
  "folke/flash.nvim",
  optional = true,
  opts = function(_, opts)
    opts.modes = opts.modes or {}
    opts.modes.char = opts.modes.char or {}
    opts.modes.char.enabled = true
    -- Exclude filetypes that don't have treesitter parsers or cause issues
    opts.modes.char.exclude = vim.list_extend(opts.modes.char.exclude or {}, {
      "mason",
      "snacks_dashboard",
      "notify",
    })
  end,
}
