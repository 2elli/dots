---- bootstrap lazy.nvim ----
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

---- lazy plugins ----
require("lazy").setup({
    -- plugins are setup here if they include "opts"
    -- theme
    { "EdenEast/nightfox.nvim" },
    -- deps
    { "nvim-lua/plenary.nvim" },
    { "nvim-tree/nvim-web-devicons", opts = {} },
    -- treesitter
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    -- lsp
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "neovim/nvim-lspconfig" },
    -- format
    { "stevearc/conform.nvim" },
    { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
    -- lint
    { "mfussenegger/nvim-lint" },
    -- snippets
    {
        "chrisgrieser/nvim-scissors",
        opts = {
            snippetDir = vim.fn.expand(vim.fn.stdpath("config") .. "/snippets/"),
            editSnippetPopup = {
                keymaps = { deleteSnippet = "<M-BS>" },
            },
            jsonFormatter = "jq",
        },
    },
    -- autocomplete
    {
        "saghen/blink.cmp",
        dependencies = "rafamadriz/friendly-snippets",
        version = "*",
        opts = {
            sources = {
                default = { "lazydev", "snippets", "lsp", "path", "buffer" },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100,
                    },
                },
            },
            keymap = require("keymaps").blink_binds(),
            appearance = { use_nvim_cmp_as_default = true, nerd_font_variant = "mono" },
            signature = { enabled = true }, -- show signature help
            completion = {
                -- show lsp docs of option
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 0,
                },
                -- list selection behavior
                list = { selection = { preselect = false, auto_insert = false } },
                -- menu appearance
                menu = {
                    draw = {
                        columns = { { "label", "label_description", gap = 1 }, { "kind" }, { "kind_icon" } },
                    },
                },
            },
        },
    },
    -- diagnostics
    { "folke/trouble.nvim", opts = {}, cmd = "Trouble" },
    -- ui
    { "RRethy/vim-illuminate" },
    { "stevearc/dressing.nvim", opts = {} },
    { "SmiteshP/nvim-navic" },
    { "j-hui/fidget.nvim", opts = {} },
    {
        "nvim-lualine/lualine.nvim",
        opts = {
            options = {
                component_separators = { left = "|", right = "|" },
                section_separators = { left = "", right = "" },
            },
        },
    },
    { "sphamba/smear-cursor.nvim", opts = { stiffness = 0.8, trailing_stiffness = 0.5, distance_stop_animating = 0.5, hide_target_hack = false } },
    -- files
    { "ThePrimeagen/harpoon", branch = "harpoon2" },
    { "stevearc/oil.nvim", opts = {} },
    -- sessions
    { "olimorris/persisted.nvim", opts = { autostart = false } },
    -- aux
    { "nvim-telescope/telescope.nvim", branch = "0.1.x" },
    { "mbbill/undotree", cmd = "UndotreeToggle" },
    { "numToStr/Comment.nvim", opts = {} },
    { "lewis6991/gitsigns.nvim", opts = {} },
    { "chentoast/marks.nvim", event = "VeryLazy", opts = {} },
    {
        "folke/snacks.nvim",
        opts = {
            -- show indent lines
            indent = { animate = { enabled = false } },
            -- disable some things for big files
            bigfile = {},
            -- scratch buffer
            scratch = {},
        },
    },
    -- python
    { "linux-cultist/venv-selector.nvim", branch = "regexp", lazy = false, opts = {} },
    -- neovim development
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
            -- only load if lazydev_enabled is set
            enabled = function(_)
                return vim.g.lazydev_enabled == nil and false or vim.g.lazydev_enabled
            end,
        },
    },
})

---- colors ----
vim.opt.background = "dark"
vim.cmd.colorscheme("carbonfox")

---- treesitter ----
require("nvim-treesitter.configs").setup({
    ensure_installed = { "c", "cpp", "python", "lua", "bash" },
    auto_install = true,
    highlight = {
        enable = true,
    },
})

---- LSP ----
vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "✘",
            [vim.diagnostic.severity.WARN] = "▲",
            [vim.diagnostic.severity.HINT] = "⚑",
            [vim.diagnostic.severity.INFO] = "",
        },
    },
})

---- setup and install lsp's ----
-- note: LspAttach is configured in cmds.lua
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "basedpyright", "bashls", "clangd", "jdtls", "rust_analyzer", "ts_ls", "jsonls" },
    -- handlers for different lsp's
    handlers = {
        -- generic handler
        function(server_name)
            require("lspconfig")[server_name].setup(
                { capabilities = require("blink.cmp").get_lsp_capabilities() }
            )
        end,

        -- custom handlers
        basedpyright = function()
            require("lspconfig").basedpyright.setup({
                capabilities = require("blink.cmp").get_lsp_capabilities(),
                settings = {
                    basedpyright = {
                        analysis = {
                            typeCheckingMode = "basic",
                        },
                    },
                },
            })
        end,

        lua_ls = function()
            require("lspconfig").lua_ls.setup({
                -- ignore global "vim" and dont align tables
                capabilities = require("blink.cmp").get_lsp_capabilities(),
                settings = {
                    Lua =
                    {
                        format = {
                            enable = true,
                            defaultConfig = {
                                align_array_table = "false",
                                trailing_table_separator = "smart",
                            },
                        },
                    },
                },
            })
        end,

        clangd = function()
            require("lspconfig").clangd.setup({
                capabilities = require("blink.cmp").get_lsp_capabilities(),
                -- dont format with clangd
                on_attach = function(client)
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentFormattingRangeProvider = false
                end,
                cmd = {
                    "clangd",
                    "--offset-encoding=utf-16",
                },
            })
        end,
    },
})

-- formatting
require("conform").setup({
    notify_no_formatters = true,
    default_format_opts = {
        lsp_format = "fallback",
    },
    formatters_by_ft = {
        python = { "black", "docformatter", "usort" },
        c = { "clangformat" },
        cpp = { "clangformat" },
    },
    formatters = {
        clangformat = {
            command = "clang-format",
            args = "--style=\"{UseTab: Always, IndentWidth: 4, TabWidth: 4, ColumnLimit: 200}\"",
        },
    },
})

-- linting
require("lint").linters_by_ft = {
    bash = { "shellcheck" },
}
-- linters that will be used by all file types
_G.global_linters = { "typos" }

-- harpoon
local harpoon = require("harpoon")
harpoon:setup({
    settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
    },
})

-- telescope extensions
require("telescope").load_extension("persisted")

---- plugin keybinds ----
require("keymaps").plugin_binds()

---- cmds and autocmds ----
require("cmds").setup_cmds()
