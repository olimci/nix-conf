local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

local lualine_saikano = {
  normal   = { a = { bg = "#8edfe8", fg = "#071315", gui = "bold" },
               b = { bg = "#3c5155", fg = "#f2f8fa" },
               c = { bg = "#071315", fg = "#f2f8fa" } },
  insert   = { a = { bg = "#b5e9d0", fg = "#071315", gui = "bold" } },
  visual   = { a = { bg = "#c3a3e8", fg = "#071315", gui = "bold" } },
  replace  = { a = { bg = "#ff5f6e", fg = "#071315", gui = "bold" } },
  command  = { a = { bg = "#e9efcc", fg = "#071315", gui = "bold" } },
  inactive = { a = { bg = "#071315", fg = "#3c5155" },
               b = { bg = "#071315", fg = "#3c5155" },
               c = { bg = "#071315", fg = "#3c5155" } },
}

require("lazy").setup({
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "lewis6991/gitsigns.nvim" },
  { "folke/which-key.nvim" },
  { "nvim-lualine/lualine.nvim" },
  { "goolord/alpha-nvim" },
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },
  {
    "VonHeikemen/lsp-zero.nvim", branch = "v3.x", dependencies = {
      { "neovim/nvim-lspconfig" },
      { "hrsh7th/nvim-cmp" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "L3MON4D3/LuaSnip" }
    }
  },
  { "numToStr/Comment.nvim", config = function() require("Comment").setup() end },
  { "windwp/nvim-autopairs", config = function() require("nvim-autopairs").setup() end },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip"
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        completion = { completeopt = "menu,menuone,noinsert" },
        experimental = { ghost_text = true },
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end
  }
})

require("colors.pochi")

require("nvim-treesitter.configs").setup({
  ensure_installed = { "lua", "python", "go", "javascript", "typescript", "rust", "c", "cpp", "json", "yaml", "toml", "bash", "markdown" },
  highlight = { enable = true },
})

require("telescope").setup({
  defaults = { file_ignore_patterns = { "node_modules", ".git" } }
})
vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, {})
vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep, {})

local lsp = require("lsp-zero").preset({})
lsp.on_attach(function(_, bufnr)
  local opts = { buffer = bufnr, noremap = true, silent = true }
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
end)
lsp.setup()

require("gitsigns").setup()

require("which-key").setup()

require("lualine").setup({
  options = { theme = lualine_saikano },
})

require("alpha").setup(require("alpha.themes.dashboard").config)

require("nvim-tree").setup({
  view = { width = 30, side = "left" },
  update_focused_file = { enable = true },
})
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { noremap = true, silent = true })

vim.keymap.set("v", "<Tab>", ">gv", { noremap = true, silent = true })
vim.keymap.set("v", "<S-Tab>", "<gv", { noremap = true, silent = true })

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true

vim.opt.clipboard = "unnamedplus"
