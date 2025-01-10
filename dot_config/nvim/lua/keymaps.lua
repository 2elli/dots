-- keybinds --
local M = {}
---Sets default keymaps that do not require plugins
M.builtin_binds = function()
    vim.g.mapleader = " "
    vim.keymap.set("n", "<SPACE>", "<Nop>")
    vim.keymap.set("n", "<leader>w", "<CMD>w<cr>")
    vim.keymap.set("n", "<leader>q", "<CMD>x<cr>")
    -- append next line
    vim.keymap.set("n", "J", "mzJ`z")
    -- keep page dwn + up centered
    vim.keymap.set("n", "<C-d>", "<C-d>zz")
    vim.keymap.set("n", "<C-u>", "<C-u>zz")
    -- keep searching dwn + up centered
    vim.keymap.set("n", "n", "nzzzv")
    vim.keymap.set("n", "N", "Nzzzv")
    -- clear search highlight
    vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
    -- meta + j|k to move selection
    vim.keymap.set("v", "<M-j>", "<CMD>m '>+1<CR>gv=gv")
    vim.keymap.set("v", "<M-k>", "<CMD>m '<-2<CR>gv=gv")
    vim.keymap.set("n", "<M-j>", "<CMD>m .+1<CR>==")
    vim.keymap.set("n", "<M-k>", "<CMD>m .-2<CR>==")
    -- delete without copying to register
    vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])
    -- tabs
    vim.keymap.set("n", "<leader>tn", "<CMD>tabn<CR>")
    vim.keymap.set("n", "<leader>tp", "<CMD>tabp<CR>")
    vim.keymap.set("n", "<leader>te", "<CMD>tabe<CR>")
    vim.keymap.set("n", "<leader>tc", "<CMD>tabc<CR>")
end

---Sets all lsp keybindings
---@param opts table  # "opts" table with buffer to be used in keymap
M.lsp_binds = function(opts)
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
    vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
    vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "gt", function() vim.lsp.buf.type_definition() end, opts)
    vim.keymap.set("n", "<leader>lh", function() vim.lsp.buf.signature_help() end, opts)
    vim.keymap.set("n", "<leader>la", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>lr", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set({ "n", "v" }, "<leader>lf", function() vim.lsp.buf.format() end, opts)
end

---Sets keybinds for all plugins
---@param plugins {harpoon: table, telescope_builtin: table}  # table of any plugins that need to be called directly in keymaps
M.plugin_binds = function(plugins)
    local harpoon = plugins.harpoon
    local telescope_builtin = plugins.telescope_builtin

    -- harpoon
    vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
    vim.keymap.set("n", "<leader>f", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
    vim.keymap.set("n", "<C-n>", function() harpoon:list():next() end)
    vim.keymap.set("n", "<C-p>", function() harpoon:list():prev() end)

    -- trouble
    vim.keymap.set("n", "<leader>xx", "<CMD>Trouble diagnostics toggle filter.buf=0<cr>")
    vim.keymap.set("n", "<leader>xX", "<CMD>Trouble diagnostics toggle<cr>")

    -- scissors
    vim.keymap.set("n", "<leader>se", function() require("scissors").editSnippet() end)
    vim.keymap.set({ "n", "x" }, "<leader>sa", function() require("scissors").addNewSnippet() end)

    -- toggle oil file "tree"
    vim.keymap.set("n", "<leader>e", function() vim.cmd((vim.bo.filetype == 'oil') and 'bd' or 'Oil') end)

    -- telescope and fzf
    vim.keymap.set("n", "<leader>T", telescope_builtin.builtin, {})
    vim.keymap.set("n", "<leader>\"", telescope_builtin.registers, {})
    vim.keymap.set("n", "<leader>/", telescope_builtin.live_grep, {})
    vim.keymap.set("n", "<leader>F", telescope_builtin.find_files, {})

    -- git
    vim.keymap.set("n", "<leader>gg", "<CMD>Gitsigns<cr>")
    vim.keymap.set("n", "<leader>gb", "<CMD>Gitsigns blame_line<cr>")
    vim.keymap.set("n", "<leader>gB", "<CMD>Gitsigns blame<cr>")
    vim.keymap.set("n", "<leader>gd", "<CMD>vert rightb Gitsigns diffthis<cr>")
    vim.keymap.set("n", "<leader>gn", "<CMD>Gitsigns next_hunk<cr>")
    vim.keymap.set("n", "<leader>gp", "<CMD>Gitsigns prev_hunk<cr>")

    -- marks
    vim.keymap.set("n", "<leader>m", "<CMD>MarksListAll<cr>")

    --[[ binds automatically setup by Comment.nvim
    NORMAL
    `gcc` - Toggles the current line using linewise comment
    `gbc` - Toggles the current line using blockwise comment
    `[count]gcc` - Toggles the number of line given as a prefix-count using linewise
    `[count]gbc` - Toggles the number of line given as a prefix-count using blockwise
    `gc[count]{motion}` - (Op-pending) Toggles the region using linewise comment
    `gb[count]{motion}` - (Op-pending) Toggles the region using blockwise comment
    VISUAL
    `gc` - Toggles the region using linewise comment
    `gb` - Toggles the region using blockwise comment
    ]]
end

---Returns table used by blink to set cmp keybinds
M.blink_binds = function()
    return {
        -- use default keys as base
        preset = "default",
        -- add "super-tab" like actions
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
    }
end

return M
