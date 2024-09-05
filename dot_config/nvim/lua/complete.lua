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
    { "nvim-lua/plenary.nvim" },

    { "VonHeikemen/lsp-zero.nvim",        branch = "v4.x" },

    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },

    { "neovim/nvim-lspconfig" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/nvim-cmp" },
    { "nvim-treesitter/nvim-treesitter", dependencies = { "JoosepAlviste/nvim-ts-context-commentstring", },
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
    { "nvim-lualine/lualine.nvim" },
    { "nvim-telescope/telescope.nvim",       tag = "0.1.6", },
    { "numToStr/Comment.nvim",               lazy = false, },
    { "lukas-reineke/indent-blankline.nvim", main = "ibl",  opts = {} },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {},
    },
    { "stevearc/dressing.nvim" },

    { "RRethy/vim-illuminate" },
    { "lewis6991/gitsigns.nvim" },

    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
    },

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

    { "EdenEast/nightfox.nvim" },
})


vim.opt.background = "dark"
vim.cmd.colorscheme "carbonfox"


require("nvim-treesitter.configs").setup({
    ensure_installed = {"c", "cpp", "python", "lua", "bash"},
    auto_install = true,
    highlight = {
        enable = true,
    },
})

--- LSP ---
local lsp_zero = require("lsp-zero")

local lsp_attach = function(client, bufnr)
    local opts = {buffer = bufnr}
    lsp_zero.default_keymaps({ buffer = bufnr })
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

local cmp = require("cmp")

cmp.setup({
    sources = {
        {name = 'nvim_lsp'},
    },
    mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping.select_next_item({behavoir = 'select'}),
        ["<S-Tab>"] = cmp.mapping.select_prev_item({behavoir = 'select'}),
        ['<CR>'] = cmp.mapping.confirm({select = false}),
    }),
    snippet = {
        expand = function(args)
            vim.snippet.expand(args.body)
        end,
    },
})
-----------


require("nvim-tree").setup()
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

require("lualine").setup({
    options = {
        theme = "auto",
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
    },
})

require("ibl").setup({ scope = { enabled = false } })
require("nvim-autopairs").setup()
require("gitsigns").setup()
require("Comment").setup()
require("dressing").setup()

-- harpoon
local harpoon = require("harpoon")
harpoon:setup()

-- fzf
local builtin = require("telescope.builtin")

---- keybinds ----
-- lsp
vim.keymap.set("n", "<leader>lf", function() vim.lsp.buf.format() end)
vim.keymap.set("n", "<leader>la", function() vim.lsp.buf.code_action() end)
vim.keymap.set("n", "<leader>lr", function() vim.lsp.buf.rename() end)

-- fzf
vim.keymap.set("n", "<leader>/", builtin.live_grep, {})

-- persistence
vim.keymap.set("n", "<leader>Sc", function() require("persistence").load() end)
vim.keymap.set("n", "<leader>Sl", function() require("persistence").load({ last = true }) end)
vim.keymap.set("n", "<leader>Sq", function() require("persistence").stop() end)

-- harpoon
vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<leader>f", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
vim.keymap.set("n", "<C-n>", function() harpoon:list():next() end)
vim.keymap.set("n", "<C-p>", function() harpoon:list():prev() end)
------------------
