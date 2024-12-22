-- auto commands --
-- setup lsp keymaps
vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP actions and keymaps",
    callback =
        function(event)
            local client = vim.lsp.get_client_by_id(event.data.client_id)
            local bufnr = event.buf

            -- map lsp keybinds
            require("keymaps").lsp_binds({ buffer = bufnr })

            -- add navic status
            if client ~= nil and client.server_capabilities.documentSymbolProvider then
                require("nvim-navic").attach(client, bufnr)
                vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
            end
        end,
})

-- closes nvim tree if it's the last window
-- from https://github.com/ppwwyyxx
vim.api.nvim_create_autocmd("QuitPre", {
    callback = function()
        local invalid_win = {}
        local wins = vim.api.nvim_list_wins()
        for _, w in ipairs(wins) do
            local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
            if bufname:match("NvimTree_") ~= nil then
                table.insert(invalid_win, w)
            end
        end
        if #invalid_win == #wins - 1 then
            -- Should quit, so we close all invalid windows.
            for _, w in ipairs(invalid_win) do vim.api.nvim_win_close(w, true) end
        end
    end
})

-- user commands --
vim.api.nvim_create_user_command(
    "Venv",
    function()
        vim.print(require("venv-selector").venv())
    end,
    { desc = "Get Current Python Venv", }
)

-- get lsp capabilities
-- vim.print(vim.lsp.get_clients()[1].server_capabilities)
