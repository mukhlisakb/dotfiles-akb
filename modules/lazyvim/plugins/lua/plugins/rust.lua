return {
  -- rustaceanvim: Modern Rust development in Neovim
  -- Provides rust-analyzer integration, debugging, and more.
  {
    "mrcjkb/rustaceanvim",
    version = "^5", -- Recommended
    lazy = false, -- This plugin is already lazy
    init = function()
      vim.g.rustaceanvim = {
        server = {
          on_attach = function(client, bufnr)
            -- Add any custom keymaps here if needed
          end,
          default_settings = {
            -- rust-analyzer language server configuration
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = false,
              },
              -- Add clippy lints for checkOnSave
              checkOnSave = false,
              procMacro = {
                enable = true,
              },
            },
          },
        },
      }
    end,
  },

  -- crates.nvim: Manage crates.io dependencies
  -- Provides completion for crate names and versions in Cargo.toml
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      completion = {
        cmp = { enabled = true },
      },
    },
  },
}
