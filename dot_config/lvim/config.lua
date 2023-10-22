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

-- set a formatter, this will override the language server formatting capabilities (if it exists)
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { command = "yapf", filetypes = { "python" } },
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
    event = "BufReadPre"
  }
}

---- plugin config
-- restore the session for the current directory
vim.api.nvim_set_keymap("n", "<leader>ms", [[<cmd>lua require("persistence").load()<cr>]], {})

-- restore the last session
vim.api.nvim_set_keymap("n", "<leader>ml", [[<cmd>lua require("persistence").load({ last = true })<cr>]], {})

-- stop Persistence => session won't be saved on exit
vim.api.nvim_set_keymap("n", "<leader>md", [[<cmd>lua require("persistence").stop()<cr>]], {})
