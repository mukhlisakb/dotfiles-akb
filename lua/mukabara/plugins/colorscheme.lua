return {
  "catppuccin/nvim",
  priority = 1000,
  config = function()
    local transparent = true -- aktifkan transparansi
    local transparency_level = "33" -- transparansi 80% (80% opacity = 20% transparent)

    -- Variabel warna untuk tema
    local bg = "#2e1f44" -- Warna latar belakang gelap untuk "frappe"
    local bg_dark = "#1e1531" -- Warna latar belakang lebih gelap
    local bg_highlight = "#5c3b6e" -- Warna latar belakang highlight
    local bg_search = "#7a4b6b" -- Warna latar belakang untuk highlight pencarian
    local bg_visual = "#6f3b5c" -- Warna latar belakang untuk seleksi visual
    local fg = "#D9E0EE" -- Warna foreground terang
    local fg_dark = "#B4B9D5" -- Warna foreground gelap
    local fg_gutter = "#8A7F99" -- Warna untuk gutter (nomor baris, dll.)
    local border = "#8A7F99" -- Warna border untuk jendela mengambang

    -- Menyiapkan tema Catppuccin dengan "frappe" flavour
    require("catppuccin").setup({
      flavour = "frappe", -- Pilih "frappe" flavour
      transparent_background = transparent, -- Aktifkan latar belakang transparan
      term_colors = true, -- Aktifkan warna terminal
      integrations = {
        cmp = true, -- Aktifkan integrasi untuk nvim-cmp
        treesitter = true, -- Aktifkan integrasi untuk nvim-treesitter
        lsp = false, -- Nonaktifkan integrasi LSP untuk menghindari kesalahan
        -- Nonaktifkan integrasi lain jika tidak dibutuhkan
      },
      on_colors = function(colors)
        -- Atur warna latar belakang dan transparansi untuk elemen tertentu
        colors.bg = transparent and "#2e1f44" .. transparency_level or bg
        colors.bg_dark = transparent and "#1e1531" .. transparency_level or bg_dark
        colors.bg_highlight = bg_highlight
        colors.bg_popup = transparent and "#1e1531" .. transparency_level or bg_dark
        colors.bg_search = bg_search
        colors.bg_sidebar = transparent and "#1e1531" .. transparency_level or bg_dark
        colors.bg_statusline = transparent and "#1e1531" .. transparency_level or bg_dark
        colors.bg_visual = bg_visual
        colors.border = border
        colors.fg = fg
        colors.fg_dark = fg_dark
        colors.fg_float = fg
        colors.fg_gutter = fg_gutter
        colors.fg_sidebar = fg_dark
      end,
    })

    vim.cmd("colorscheme catppuccin")
  end,
}
