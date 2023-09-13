-- .nvimrc, neovim config file 2elli 
vim.g.mapleader = " "
vim.keymap.set("n", "<SPACE>", "<Nop>")
vim.keymap.set("n", "<leader>w", ":w<cr>")
vim.keymap.set("n", "<leader>q", ":wq<cr>")

vim.opt.nu=true
vim.opt.tabstop=4
vim.opt.expandtab=true
vim.opt.shiftwidth=4
vim.opt.tabstop=4

vim.opt.autoindent=true
vim.opt.copyindent=true
vim.opt.clipboard="unnamedplus"

vim.opt.scrolloff=8

-- keybinds
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- search options
vim.opt.ignorecase=true

