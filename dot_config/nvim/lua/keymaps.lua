-- keybinds --
---Sets default keymaps that do not require plugins
local function builtin_binds()
    vim.g.mapleader = " "
    vim.keymap.set("n", "<SPACE>", "<Nop>")
    vim.keymap.set("n", "<leader>w", ":w<cr>")
    vim.keymap.set("n", "<leader>q", ":x<cr>")
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
    -- yank/paste to system clipboard
    vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
    vim.keymap.set("n", "<leader>Y", [["+Y]])
    vim.keymap.set({ "n", "v" }, "<leader>p", [["+p]])
    vim.keymap.set("n", "<leader>P", [["+P]])
    -- delete without copying to register
    vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])
    -- tabs
    vim.keymap.set("n", "<leader>tn", ":tabn<CR>")
    vim.keymap.set("n", "<leader>tp", ":tabp<CR>")
    vim.keymap.set("n", "<leader>te", ":tabe<CR>")
    vim.keymap.set("n", "<leader>tc", ":tabc<CR>")
end

---Sets all lsp keybindings
---@param opts table  # "opts" table with buffer to be used in keymap
local function lsp_binds(opts)
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

    -- telescope and fzf
    vim.keymap.set("n", "<leader>T", telescope_builtin.builtin, {})
    vim.keymap.set("n", "<leader>\"", telescope_builtin.registers, {})
    vim.keymap.set("n", "<leader>/", telescope_builtin.live_grep, {})
    vim.keymap.set("n", "<leader>F", telescope_builtin.find_files, {})

    -- git
    vim.keymap.set("n", "<leader>gg", ":Gitsigns<cr>")
    vim.keymap.set("n", "<leader>gb", ":Gitsigns blame_line<cr>")
    vim.keymap.set("n", "<leader>gB", ":Gitsigns blame<cr>")
    vim.keymap.set("n", "<leader>gd", ":vert rightb Gitsigns diffthis<cr>")
    vim.keymap.set("n", "<leader>gn", ":Gitsigns next_hunk<cr>")
    vim.keymap.set("n", "<leader>gp", ":Gitsigns prev_hunk<cr>")

    -- marks
    vim.keymap.set("n", "<leader>m", ":MarksListAll<cr>")

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

--- get keymaps for cmp
--- @param cmp table table of mappings to insert into cmp.mapping.preset
local function cmp_binds(cmp)
    return {
        -- Super tab
        ["<Tab>"] = cmp.mapping(
            function(fallback)
                local luasnip = require("luasnip")
                local col = vim.fn.col(".") - 1

                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_locally_jumpable() then
                    luasnip.expand_or_jump()
                elseif col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
                    fallback()
                else
                    cmp.complete()
                end
            end, { "i", "s" }),

        -- Super shift tab
        ["<S-Tab>"] = cmp.mapping(
            function(fallback)
                local luasnip = require("luasnip")

                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.locally_jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s" }),

        -- enter to confirm selection
        ["<CR>"] = cmp.mapping.confirm({ select = false }),

        -- scroll up and down the documentation window
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
    }
end


return { builtin_binds = builtin_binds, lsp_binds = lsp_binds, plugin_binds = plugin_binds, cmp_binds = cmp_binds }
