-- dotfiles/nvim/lua/lsp/handlers.lua
-- LSPアタッチ時のキーマップとイベント設定

-- conform.nvimのチェック
local conform_ok, conform = pcall(require, 'conform')

-- LSPのキーマップ設定
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }

        -- 基本的なLSP機能
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)

        -- リファクタリング
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({'n', 'v'}, '<space>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

        -- 診断機能
        vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

        -- フォーマット(conform.nvim を優先、フォールバックでLSP)
        vim.keymap.set('n', '<space>f', function()
            if conform_ok then
                conform.format({ async = true, lsp_fallback = true})
            else
                vim.lsp.buf.format({ async = true })
            end
        end, opts)
    end,
})
