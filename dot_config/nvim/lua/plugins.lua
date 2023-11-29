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
    {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring", },
    },
    "nvim-tree/nvim-web-devicons",
    "nvim-tree/nvim-tree.lua",
    "nvim-lualine/lualine.nvim",

    { "hrsh7th/nvim-cmp"
    , dependencies = 
        { "hrsh7th/cmp-nvim-lsp"
        , "hrsh7th/cmp-nvim-lua"
        , "hrsh7th/cmp-buffer"
        , "hrsh7th/cmp-path"
        , "hrsh7th/cmp-cmdline"
        , "saadparwaiz1/cmp_luasnip" }
    },
    "L3MON4D3/LuaSnip",
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
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 400
      end,
      opts = {}
    },
    "stevearc/dressing.nvim",

    "RRethy/vim-illuminate",
    "lewis6991/gitsigns.nvim",

    "ThePrimeagen/harpoon",

    "EdenEast/nightfox.nvim",

    "RaafatTurki/hex.nvim",
})

vim.opt.background = "dark"
vim.cmd.colorscheme "carbonfox"

require("nvim-tree").setup()
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

require("lualine").setup({
    options = {
        theme = "auto",
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
    },
})

require("nvim-treesitter.configs").setup({
  ensure_installed = 
    { "c"
    , "cpp"
    , "python"
    , "lua"
    , "vim"
    , "vimdoc" },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
  },
})

require('ts_context_commentstring').setup()

local cmp = require("cmp")
require("cmp").setup({
	snippet = {
		expand = function(args)
			-- snippet engine luasnip
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "nvim_lua" },
		{ name = "luasnip" },
		{ name = "treesitter" },
		{ name = "buffer" },
		{ name = "path" },
	}),
})

require("ibl").setup()
require("nvim-autopairs").setup()
require("gitsigns").setup()
require("Comment").setup()
require("dressing").setup()
require("hex").setup()

-- harpoon
require("harpoon").setup()
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<leader>f", ui.toggle_quick_menu)

vim.keymap.set("n", "<C-b>", function() ui.nav_next() end)
vim.keymap.set("n", "<C-n>", function() ui.nav_prev() end)
--

local wk = require("which-key")
wk.register(mappings, opts)
