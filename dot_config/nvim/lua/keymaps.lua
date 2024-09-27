---- keybinds ----

---Loads default keymaps that do not require plugins
local function builtin_binds()
    vim.g.mapleader = " "
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
    -- yank to system clipboard
    vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
    vim.keymap.set("n", "<leader>Y", [["+Y]])
    -- delete without copying to register
    vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])
end

---Loads all lsp keybindings
---@param opts table  # "opts" table with buffer to be used in keymap
local function lsp_binds(opts)
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
    vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
    vim.keymap.set("n", "go", function() vim.lsp.buf.type_definition() end, opts)
    vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "gs", function() vim.lsp.buf.signature_help() end, opts)
    vim.keymap.set({ "n", "v" }, "<leader>lf", function() vim.lsp.buf.format() end, opts)
    vim.keymap.set("n", "<leader>la", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>lr", function() vim.lsp.buf.rename() end, opts)
end

---loads keybinds for plugins
---@param plugins {harpoon: table, telescope_builtin: table}  # table of any plugins that need to be called directly in keymaps
local function plugin_binds(plugins)
    local harpoon = plugins.harpoon
    local telescope_builtin = plugins.telescope_builtin

    -- harpoon
    vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
    vim.keymap.set("n", "<leader>f", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
    vim.keymap.set("n", "<C-n>", function() harpoon:list():next() end)
    vim.keymap.set("n", "<C-p>", function() harpoon:list():prev() end)

    -- trouble
    vim.keymap.set("n", "<leader>xx", ":Trouble diagnostics toggle filter.buf=0<cr>")
    vim.keymap.set("n", "<leader>xX", ":Trouble diagnostics toggle<cr>")

    -- scissors
    vim.keymap.set("n", "<leader>se", function() require("scissors").editSnippet() end)
    vim.keymap.set({ "n", "x" }, "<leader>sa", function() require("scissors").addNewSnippet() end)

    -- file tree
    vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

    -- telescope fzf
    vim.keymap.set("n", "<leader>/", telescope_builtin.live_grep, {})

    -- persistence
    vim.keymap.set("n", "<leader>Sc", function() require("persistence").load() end)
    vim.keymap.set("n", "<leader>Sl", function() require("persistence").load({ last = true }) end)
    vim.keymap.set("n", "<leader>Sq", function() require("persistence").stop() end)
    vim.keymap.set("n", "<leader>SS", function() require("persistence").select() end)
end

return { builtin_binds = builtin_binds, lsp_binds = lsp_binds, plugin_binds = plugin_binds }