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
    "neovim/nvim-lspconfig",
    lazy = true,
    dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
    },
    { "nvimtools/none-ls.nvim", lazy = true },
    {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring", },
    },
    "nvim-tree/nvim-web-devicons",
    "nvim-tree/nvim-tree.lua",
    {"akinsho/bufferline.nvim", version = "*"},
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
        vim.o.timeoutlen = 300
      end,
      opts = {}
    },
    "stevearc/dressing.nvim",

    "RRethy/vim-illuminate",
    "lewis6991/gitsigns.nvim",

    "EdenEast/nightfox.nvim",
})

vim.opt.background = "dark"
vim.cmd.colorscheme "carbonfox"

require("mason").setup()
require("mason-lspconfig").setup()

local lspconfig = require("lspconfig")
lspconfig.rust_analyzer.setup({})
lspconfig.clangd.setup({})
lspconfig.pyright.setup({})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    -- vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workleader_folder, opts)
    -- vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workleader_folder, opts)
    -- vim.keymap.set("n", "<leader>wl", function()
    --   print(vim.inspect(vim.lsp.buf.list_workleader_folders()))
    -- end, opts)
    -- vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
    -- vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    -- vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
    -- vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    -- vim.keymap.set("n", "<leader>f", function()
    -- vim.lsp.buf.format { async = true }
    -- end, opts)
  end,
})

require("nvim-tree").setup()

require("bufferline").setup()

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

require('gitsigns').setup()

require('Comment').setup()

require("dressing").setup()

local wk = require("which-key")
wk.register(mappings, opts)
