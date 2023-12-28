-- disabled netrw for neo-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

require("lazy").setup({
    {
    "neovim/nvim-lspconfig",
    lazy = true,
    dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
    },
    { "nvimtools/none-ls.nvim", lazy = true },
    {"akinsho/bufferline.nvim", version = "*"},
})

require("mason").setup()
require("mason-lspconfig").setup()

local lspconfig = require("lspconfig")
lspconfig.rust_analyzer.setup({})
lspconfig.clangd.setup({})
lspconfig.pyright.setup({})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    -- vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workleader_folder, opts)
    -- vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workleader_folder, opts)
    -- vim.keymap.set("n", "<leader>wl", function()
    --   print(vim.inspect(vim.lsp.buf.list_workleader_folders()))
    -- end, opts)
    -- vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
    -- vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    -- vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
    -- vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    -- vim.keymap.set("n", "<leader>f", function()
    -- vim.lsp.buf.format { async = true }
    -- end, opts)
  end,
})

require("bufferline").setup()
