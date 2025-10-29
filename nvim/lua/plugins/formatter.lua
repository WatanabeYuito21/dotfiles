-- dotfiles/nvim/lua/plugins/formatter.lua
-- -- フォーマッター関連のプラグイン設定

return {
    {
        'stevearc/conform.nvim',
        event = { 'BufWritePre' },
        cmd = { 'ConformInfo'},
        config = function()
            local conform = require('conform')

            conform.setup({
                formatters_by_ft = {
                    python = { 'black', 'isort' },
                    javascript = { 'prettier' },
                    typepscript = { 'prettier' },
                    rust = { 'rustfmt' },
                    lua = { 'stylua' },
                    go = { 'gofmt' },
                    powerml = { 'pwshfmt' },
                    markdown = { 'prettier' },
                },

                -- Automatically format on save
                format_on_save = {
                    timeout_ms = 500,
                    lsp_fallback = true,
                },

                -- Custom formatter settings
                formatters = {
                    black = {
                        args = {'--fast', '--quiet', '-'},
                    },
                    isort = {
                        args = {'--profile', 'black','--quiet', '-'},
                    },
                },
            })

            -- Create a command for manual formatting
            vim.api.nvim_create_user_command("Format",function(args)
                local range = nil
                if args.count ~= -1 then
                    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
                    range = {
                        start = { args.line1, 0 },
                        ['end'] = { args.line2, end_line:len() },
                    }
                end
                conform.format({ async = true, lsp_fallback = true, range = range })
            end, {range = true})
        end,
    },
}
