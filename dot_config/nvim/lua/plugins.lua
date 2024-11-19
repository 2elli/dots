-- disable netrw for nvim tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- setup lazy
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

---- install plugins ----
require("lazy").setup({
    -- dep
    { "nvim-lua/plenary.nvim", lazy = true },
    -- treesitter
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    -- lsp
    { "VonHeikemen/lsp-zero.nvim", branch = "v4.x" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "neovim/nvim-lspconfig" },
    { "nvimtools/none-ls.nvim" },
    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        opts = {},
        config = function(_, opts) require("lsp_signature").setup(opts) end
    },
    { "SmiteshP/nvim-navic" },
    -- snippets
    { "L3MON4D3/LuaSnip", dependencies = { "rafamadriz/friendly-snippets" }, },
    {
        "chrisgrieser/nvim-scissors",
        opts = {
            snippetDir = vim.fn.expand(vim.fn.stdpath("config") .. "/snippets/"),
        }
    },
    -- autocomplete
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/nvim-cmp" },
    { "saadparwaiz1/cmp_luasnip" },
    { "onsails/lspkind.nvim" },
    -- diagnostics
    { "folke/trouble.nvim", opts = {}, cmd = "Trouble", },
    -- ui
    { "stevearc/dressing.nvim", opts = {} },
    { "j-hui/fidget.nvim", opts = {}, },
    { "nvim-tree/nvim-web-devicons", opts = {} },
    { "nvim-lualine/lualine.nvim" },
    -- files
    { "ThePrimeagen/harpoon", branch = "harpoon2", },
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        opts = {},
    },
    -- format
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = { scope = { enabled = false } },
    },
    { "windwp/nvim-autopairs", event = "InsertEnter", opts = {}, },
    -- aux
    { "nvim-telescope/telescope.nvim", branch = "0.1.x", },
    { "chentoast/marks.nvim", event = "VeryLazy", opts = {}, },
    { "RRethy/vim-illuminate" },
    { "numToStr/Comment.nvim", opts = {} },
    { "lewis6991/gitsigns.nvim", opts = {} },
    -- theme
    { "EdenEast/nightfox.nvim" },
})

-- colors
vim.opt.background = "dark"
vim.cmd.colorscheme "carbonfox"

---- treesitter ----
require("nvim-treesitter.configs").setup({
    ensure_installed = { "c", "cpp", "python", "lua", "bash" },
    auto_install = true,
    highlight = {
        enable = true,
    },
})

---- LSP ----
local lsp_zero = require("lsp-zero")
local navic = require("nvim-navic")

-- shared lsp function for when buffer is attached to lsp
local lsp_attach = function(client, bufnr)
    -- default keybinds -> lsp_zero.default_keymaps({ buffer = bufnr })
    -- create keybinds
    local opts = { buffer = bufnr }
    require("keymaps").lsp_binds(opts)

    if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
        vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
    end
end

-- setup lsp zero capabilities and defaults
lsp_zero.extend_lspconfig({
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    lsp_attach = lsp_attach,
    float_border = "rounded",
    sign_text = {
        error = "✘",
        warn = "▲",
        hint = "⚑",
        info = ""
    },
})

-- setup and install lsp binaries
require("mason").setup({})
require("mason-lspconfig").setup({
    ensure_installed = { "pyright", "lua_ls", "clangd", "ts_ls" },
    -- handlers for different lsp's
    handlers = {
        -- generic handler
        function(server_name)
            require("lspconfig")[server_name].setup({})
        end,

        -- custom handlers
        lua_ls = function()
            require("lspconfig").lua_ls.setup({
                -- ignore global "vim" and dont align tables
                settings = {
                    Lua =
                    {
                        format = {
                            enable = true,
                            defaultConfig = {
                                align_continuous_assign_statement = "false",
                                align_continuous_rect_table_field = "false",
                                align_array_table = "false"
                            }
                        },
                        diagnostics = { globals = { "vim" }, },
                    }
                }
            })
        end,

        clangd = function()
            require("lspconfig").clangd.setup({
                -- dont format with clangd
                on_attach = function(client)
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentFormattingRangeProvider = false
                end
            })
        end,
    },
})

-- setup null-ls sources  (this is used for adding functionality, like formatting, that may not be in an lsp)
local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.clang_format.with({
            extra_args = { "--style={UseTab: Always, IndentWidth: 4, TabWidth: 4, ColumnLimit: 200}" }
        }),
    }
})

---- autocomplete & snippets ----
local cmp = require("cmp")
local lspkind = require("lspkind")

-- load snippets
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_vscode").lazy_load({
    paths = { vim.fn.expand(vim.fn.stdpath("config") .. "/snippets/"), }
})

-- setup autocomplete
local cmp_action = lsp_zero.cmp_action()
cmp.setup({
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
    }),
    mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp_action.luasnip_supertab(),
        ["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
    }),
    snippet = {
        expand = function(args)
            vim.snippet.expand(args.body)
        end,
    },
    formatting = {
        format = lspkind.cmp_format({
            mode = "symbol_text", -- show only symbol annotations
            maxwidth = 80,        -- max width of popup
            ellipsis_char = "...",
            show_labelDetails = true,
        })
    },
})

---- aux ----
-- bottom status line
require("lualine").setup({
    options = {
        theme = "auto",
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
    },
})

-- harpoon marks
local harpoon = require("harpoon")
harpoon:setup({
    settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
    }
})

-- fzf
local telescope_builtin = require("telescope.builtin")

---- plugin keybinds ----
require("keymaps").plugin_binds({ harpoon = harpoon, telescope_builtin = telescope_builtin })
-------------------------

---- autocmds ----
require("autocmd")
------------------