-- general
lvim.log.level = "warn"
lvim.format_on_save.enabled = false
lvim.colorscheme = "carbonfox"

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

vim.opt.nu=true
vim.opt.tabstop=4
vim.opt.expandtab=true
vim.opt.shiftwidth=4

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.relativenumber = true
vim.opt.undofile = true

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "cpp",
  "python",
  "rust",
  "haskell",
  "ocaml",
  "go",
  "lua",
  "java",
  "javascript",
  "typescript",
  "tsx",
  "css",
  "json",
  "yaml"
}

lvim.builtin.treesitter.highlight.enable = true

vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "texlab" })

-- set a formatter, this will override the language server formatting capabilities (if it exists)
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { command = "yapf",               filetypes = { "python" } },
  { command = "google-java-format", filetypes = { "java" } }
}
-- set additional linters
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { command = "ruff", filetypes = { "python" }, args = { "--line-length=200" } }
}

-- other plugins
lvim.plugins = {
  { "EdenEast/nightfox.nvim", name = "nightfox" },
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
  {
    "ThePrimeagen/harpoon",
    config = function()
        require("harpoon").setup()
    end,
    },
}

-- harpoon
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")
vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<leader>h", ui.toggle_quick_menu)
vim.keymap.set("n", "<C-b>", function() ui.nav_next() end)
vim.keymap.set("n", "<C-n>", function() ui.nav_prev() end)


lvim.builtin.which_key.mappings["S"] = {
  name = "Session",
  c = { "<cmd>lua require('persistence').load()<cr>", "Restore last session for current dir" },
  l = { "<cmd>lua require('persistence').load({ last = true })<cr>", "Restore last session" },
  Q = { "<cmd>lua require('persistence').stop()<cr>", "Quit without saving session" },
}
