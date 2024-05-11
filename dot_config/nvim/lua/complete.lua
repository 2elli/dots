-- disabled netrw for neo-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    "nvim-lua/plenary.nvim",
    {"williamboman/mason.nvim"},
    {"williamboman/mason-lspconfig.nvim"},

    {"VonHeikemen/lsp-zero.nvim", branch = "v3.x"},
    {"neovim/nvim-lspconfig"},
    {"hrsh7th/cmp-nvim-lsp"},
    {"hrsh7th/nvim-cmp"},
    {"L3MON4D3/LuaSnip"},
    {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring", },
    },
    "nvim-tree/nvim-web-devicons",
    "nvim-tree/nvim-tree.lua",
    "nvim-lualine/lualine.nvim",
    {
    'numToStr/Comment.nvim',
    lazy = false,
    },
    { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {},
    },
    "stevearc/dressing.nvim",

    "RRethy/vim-illuminate",
    "lewis6991/gitsigns.nvim",

    "ThePrimeagen/harpoon",

    "EdenEast/nightfox.nvim",
})

vim.opt.background = "dark"
vim.cmd.colorscheme "carbonfox"

-- LSP
local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)

require('mason').setup({})
require('mason-lspconfig').setup({
  -- Replace the language servers listed here 
  -- with the ones you want to install
  ensure_installed = {'pyright', 'rust_analyzer', 'clangd'},
  handlers = {
      lsp_zero.default_setup,
  },
})

require("nvim-tree").setup()
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

require("lualine").setup({
    options = {
        theme = "auto",
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
    },
})

require("ibl").setup( { scope = { enabled = false} } )
require("nvim-autopairs").setup()
require("gitsigns").setup()
require("Comment").setup()
require("dressing").setup()

-- harpoon
require("harpoon").setup()
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<leader>f", ui.toggle_quick_menu)

vim.keymap.set("n", "<C-n>", function() ui.nav_next() end)
vim.keymap.set("n", "<C-S-N>", function() ui.nav_prev() end)
--
