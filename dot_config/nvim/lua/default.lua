-- default.lua , neovim config file 2elli 
vim.g.mapleader = " "

vim.opt.nu=true
vim.opt.relativenumber = true

vim.opt.tabstop=4
vim.opt.expandtab=true
vim.opt.shiftwidth=4

vim.opt.wrap = false
vim.opt.scrolloff=8

vim.opt.ignorecase=true

vim.opt.autoindent=true
vim.opt.copyindent=true
vim.opt.clipboard="unnamedplus"

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.nvim/undodir"

---- keybinds ----
vim.keymap.set("n", "<SPACE>", "<Nop>")
vim.keymap.set("n", "<leader>w", ":w<cr>")
vim.keymap.set("n", "<leader>q", ":q<cr>")
-- append next line
vim.keymap.set("n", "J", "mzJ`z")
-- keep page dwn + up centered
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
-- keep searching dwn + up centered
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
-- no highlight
vim.keymap.set("n", "<leader>h", ":noh<CR>")
-- meta + j|k to move selection
vim.keymap.set("v", "<M-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<M-k>", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "<M-j>", ":m .+1<CR>==")
vim.keymap.set("n", "<M-k>", ":m .-2<CR>==")
