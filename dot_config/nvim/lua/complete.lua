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
    -- dep
    { "nvim-lua/plenary.nvim" },
    -- treesitter
    { "nvim-treesitter/nvim-treesitter",  dependencies = { "JoosepAlviste/nvim-ts-context-commentstring", }, },
    -- lsp
    { "VonHeikemen/lsp-zero.nvim",        branch = "v4.x" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "neovim/nvim-lspconfig" },
    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        opts = {},
        config = function(_, opts) require 'lsp_signature'.setup(opts) end
    },
    -- snippets
    {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
    },
    { "chrisgrieser/nvim-scissors", },
    -- autocomplete
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/nvim-cmp" },
    { "saadparwaiz1/cmp_luasnip" },
    -- code action
    {
        "folke/trouble.nvim",
        opts = {}, -- for default options, refer to the configuration section for custom setup.
        cmd = "Trouble",
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
        },
    },
    -- ui
    { "stevearc/dressing.nvim" },
    {
        "j-hui/fidget.nvim",
        opts = {
            -- options
        },
    },
    { "nvim-lualine/lualine.nvim" },
    -- files
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
    },
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("nvim-tree").setup {}
        end,
    },
    -- format
    { "lukas-reineke/indent-blankline.nvim", main = "ibl",  opts = {} },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {},
    },
    -- aux
    { "nvim-telescope/telescope.nvim",       tag = "0.1.6", },
    {
        "chentoast/marks.nvim",
        event = "VeryLazy",
        opts = {},
    },
    { "RRethy/vim-illuminate" },
    { "numToStr/Comment.nvim",  lazy = false, },
    { "lewis6991/gitsigns.nvim" },
    -- persistence
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        lazy = true,
        config = function()
            require("persistence").setup {
                dir = vim.fn.expand(vim.fn.stdpath "config" .. "/session/"),
                options = { "buffers", "curdir", "tabpages", "winsize" },
            }
        end,
    },
    -- theme
    { "EdenEast/nightfox.nvim" },
})

vim.opt.background = "dark"
vim.cmd.colorscheme "carbonfox"

--- treesitter ---
require("nvim-treesitter.configs").setup({
    ensure_installed = { "c", "cpp", "python", "lua", "bash" },
    auto_install = true,
    highlight = {
        enable = true,
    },
})

--- LSP ---
local lsp_zero = require("lsp-zero")

local lsp_attach = function(client, bufnr)
    -- lsp_zero.default_keymaps({ buffer = bufnr })
    local opts = {buffer = bufnr}
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
    vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
    vim.keymap.set("n", "go", function() vim.lsp.buf.type_definition() end, opts)
    vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "gs", function() vim.lsp.buf.signature_help() end, opts)
    vim.keymap.set("n", "<leader>lf", function() vim.lsp.buf.format() end, opts)
    vim.keymap.set("n", "<leader>la", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>lr", function() vim.lsp.buf.rename() end, opts)
end

lsp_zero.extend_lspconfig({
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
    lsp_attach = lsp_attach,
    float_border = 'rounded',
    sign_text = true,
})

require("mason").setup({})
require("mason-lspconfig").setup({
    ensure_installed = { "pyright", "lua_ls", "rust_analyzer", "clangd" },
    handlers = {
        function(server_name)
            require('lspconfig')[server_name].setup({})
        end,
    },
})
require("lsp_signature").setup({})

--- autocomplete ---
local cmp = require("cmp")

require('luasnip.loaders.from_vscode').lazy_load()
require('luasnip.loaders.from_vscode').lazy_load({
    paths = { vim.fn.expand(vim.fn.stdpath("config") .. "/snippets/"), }
})

cmp.setup({
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
    }),
    mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping.select_next_item({ behavoir = 'select' }),
        ["<S-Tab>"] = cmp.mapping.select_prev_item({ behavoir = 'select' }),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
    }),
    snippet = {
        expand = function(args)
            vim.snippet.expand(args.body)
        end,
    },
})

-- harpoon
local harpoon = require("harpoon")
harpoon:setup()

-- ui
require("dressing").setup()
require("nvim-tree").setup()
require("lualine").setup({
    options = {
        theme = "auto",
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
    },
})

-- fzf
local builtin = require("telescope.builtin")

-- other
require("Comment").setup()
require("nvim-autopairs").setup()
require("ibl").setup({ scope = { enabled = false } })
require("gitsigns").setup()

---- keybinds ----
-- harpoon
vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<leader>f", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
vim.keymap.set("n", "<C-n>", function() harpoon:list():next() end)
vim.keymap.set("n", "<C-p>", function() harpoon:list():prev() end)

-- scissors
vim.keymap.set("n", "<leader>se", function() require("scissors").editSnippet() end)
vim.keymap.set({ "n", "x" }, "<leader>sa", function() require("scissors").addNewSnippet() end)

-- file tree
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

-- fzf
vim.keymap.set("n", "<leader>/", builtin.live_grep, {})

-- persistence
vim.keymap.set("n", "<leader>Sc", function() require("persistence").load() end)
vim.keymap.set("n", "<leader>Sl", function() require("persistence").load({ last = true }) end)
vim.keymap.set("n", "<leader>Sq", function() require("persistence").stop() end)
vim.keymap.set("n", "<leader>SS", function() require("persistence").select() end)
------------------
