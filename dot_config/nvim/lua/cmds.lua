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
