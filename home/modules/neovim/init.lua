local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.opt.termguicolors = true

require("lazy").setup({
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
          integrations = {
          treesitter = true,
          telescope = true,
          gitsigns = true,
          nvimtree = true,
          which_key = true,
          cmp = true,
          alpha = true,
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end
  },

  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "lewis6991/gitsigns.nvim" },
  { "folke/which-key.nvim" },
  { "nvim-lualine/lualine.nvim" },
  { "goolord/alpha-nvim" },
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },

  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    dependencies = {
      { "neovim/nvim-lspconfig" },
      { "hrsh7th/nvim-cmp" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "L3MON4D3/LuaSnip" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "saadparwaiz1/cmp_luasnip" },
    }
  },

  { "numToStr/Comment.nvim", config = function() require("Comment").setup() end },
  { "windwp/nvim-autopairs", config = function() require("nvim-autopairs").setup() end },
})

require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "lua","python","go","javascript","typescript","rust","c","cpp",
    "json","yaml","toml","bash","markdown"
  },
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
  vim.keymap.set("n", "K",  vim.lsp.buf.hover, opts)
end)
lsp.setup()

do
  local ok_cmp, cmp = pcall(require, "cmp")
  if ok_cmp then
    local luasnip = require("luasnip")
    cmp.setup({
      completion = { completeopt = "menu,menuone,noinsert" },
      experimental = { ghost_text = true },
      snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
      mapping = cmp.mapping.preset.insert({
        ["<Tab>"]   = cmp.mapping.select_next_item(),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        ["<CR>"]    = cmp.mapping.confirm({ select = true }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip"  },
        { name = "buffer"   },
        { name = "path"     },
      }),
    })
  end
end

require("gitsigns").setup()

require("which-key").setup()

require("lualine").setup({
  options = { theme = "catppuccin" },
})

require("alpha").setup(require("alpha.themes.dashboard").config)

require("nvim-tree").setup({
  view = { width = 30, side = "left" },
  update_focused_file = { enable = true },
})
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { noremap = true, silent = true })

vim.keymap.set("v", "<Tab>",   ">gv", { noremap = true, silent = true })
vim.keymap.set("v", "<S-Tab>", "<gv", { noremap = true, silent = true })

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.clipboard = "unnamedplus"
