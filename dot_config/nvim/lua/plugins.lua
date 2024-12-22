-- disable netrw for nvim tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Bootstrap lazy.nvim
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

---- install plugins ----
require("lazy").setup({
    -- plugin install settings
    install = { missing = true, colorscheme = { "carbonfox" }, },
    -- theme
    { "EdenEast/nightfox.nvim" },
    -- dep
    { "nvim-lua/plenary.nvim", lazy = true },
    -- treesitter
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    -- lsp
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
            editSnippetPopup = {
                keymaps = {
                    deleteSnippet = "<M-BS>", -- change to meta+backspace to fix key code issues
                },
            },
            jsonFormatter = "jq",
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
    { "stevearc/dressing.nvim", opts = {}, },
    { "j-hui/fidget.nvim", opts = {}, },
    { "nvim-tree/nvim-web-devicons", opts = {}, },
    { "nvim-lualine/lualine.nvim" },
    { "sphamba/smear-cursor.nvim", opts = { stiffness = 0.8, trailing_stiffness = 0.5, distance_stop_animating = 0.5, hide_target_hack = false, }, },
    { "RRethy/vim-illuminate" },
    -- files
    { "ThePrimeagen/harpoon", branch = "harpoon2", },
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        opts = {},
    },
    -- format
    { "windwp/nvim-autopairs", event = "InsertEnter", opts = {}, },
    -- aux
    { "nvim-telescope/telescope.nvim", branch = "0.1.x", },
    { "numToStr/Comment.nvim", opts = {}, },
    { "lewis6991/gitsigns.nvim", opts = {}, },
    { "chentoast/marks.nvim", event = "VeryLazy", opts = {}, },
    {
        "folke/snacks.nvim",
        opts = {
            indent = { animate = { enabled = false } },
        }
    },
    -- python
    { "linux-cultist/venv-selector.nvim", branch = "regexp", lazy = false, opts = {}, },
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
local lspconfig_defaults = require("lspconfig").util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
    "force",
    lspconfig_defaults.capabilities,
    require("cmp_nvim_lsp").default_capabilities()
)

-- diagnostic signs
vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "✘",
            [vim.diagnostic.severity.WARN] = "▲",
            [vim.diagnostic.severity.HINT] = "⚑",
            [vim.diagnostic.severity.INFO] = ""
        },
    },
})

-- setup and install lsp's
-- note: LspAttach is configured in cmds.lua
require("mason").setup({})
require("mason-lspconfig").setup({
    ensure_installed = { "basedpyright", "bashls", "lua_ls", "clangd", "ts_ls" },
    -- handlers for different lsp's
    handlers = {
        -- generic handler
        function(server_name)
            require("lspconfig")[server_name].setup({})
        end,

        -- custom handlers
        basedpyright = function()
            require("lspconfig").basedpyright.setup({
                settings = {
                    basedpyright = {
                        analysis = {
                            typeCheckingMode = "basic",
                        }
                    }
                }
            })
        end,

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
                end,
                cmd = {
                    "clangd",
                    "--offset-encoding=utf-16",
                },

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
cmp.setup({
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
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
    mapping = cmp.mapping.preset.insert(require("keymaps").cmp_binds(cmp)),
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

---- cmds and autocmds ----
require("cmds")
---------------------------
