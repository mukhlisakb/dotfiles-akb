return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {},
        clangd = {},
        cssls = {},
        eslint = {
          on_attach = function(client, bufnr)
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              command = "EslintFixAll",
            })
          end,
        },
        gopls = {},
        html = {},
        jsonls = {},
        marksman = {},
        sqls = {},
        tailwindcss = {},
        ts_ls = {
          init_options = {
            plugins = {
              {
                name = "@vue/typescript-plugin",
                location = vim.fn.expand(
                  vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
                ),
                languages = { "vue", "javascript", "typescript" },
              },
            },
          },
          filetypes = {
            "typescript",
            "javascript",
            "javascriptreact",
            "typescriptreact",
            "vue",
          },
        },
        vue_ls = {
          init_options = {
            vue = {
              hybridMode = false,
            },
          },
          filetypes = { "vue" },
        },
        yamlls = {},
      },
    },
  },
  {
    "hat0uma/prelive.nvim",
    cmd = {
      "PreLiveGo",
      "PreLiveStatus",
      "PreLiveClose",
      "PreLiveCloseAll",
      "PreLiveLog",
    },
    init = function()
      vim.cmd([[
        cnoreabbrev <expr> prelive (getcmdtype() == ':' && getcmdline() =~# '^prelive\\>' ? 'PreLiveGo' : 'prelive')
        cnoreabbrev <expr> prelivestop (getcmdtype() == ':' && getcmdline() =~# '^prelivestop\\>' ? 'PreLiveCloseAll' : 'prelivestop')
        cnoreabbrev <expr> preliveopen (getcmdtype() == ':' && getcmdline() =~# '^preliveopen\\>' ? 'PreLiveStatus' : 'preliveopen')
      ]])
    end,
    opts = function()
      return {
        server = {
          host = "127.0.0.1",
          port = 5500,
        },
      }
    end,
  },
}
