-- default.lua , neovim config file 2elli
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.autoindent = true
vim.opt.copyindent = true
vim.opt.smartindent = true

vim.opt.wrap = false
vim.opt.scrolloff = 8

vim.opt.ignorecase = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.nvim/undodir"

vim.opt.termguicolors = true

vim.g.have_nerd_font = true

-- session options
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- use default keybinds
require("keymaps").builtin_binds()
