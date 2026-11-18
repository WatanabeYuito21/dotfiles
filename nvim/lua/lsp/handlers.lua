-- dotfiles/nvim/lua/lsp/handlers.lua
-- LSPアタッチ時のキーマップとイベント設定

-- 診断表示の設定（LSP 以外に診断を出すプラグインは無いので、LSP の読み込みと一緒に適用する）
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

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
        vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
        vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)

        -- フォーマット(conform.nvim を優先、フォールバックでLSP)
        -- conform は押されたときに初めて読み込む
        vim.keymap.set('n', '<space>f', function()
            local ok, conform = pcall(require, 'conform')
            if ok then
                conform.format({ async = true, lsp_format = 'fallback' })
            else
                vim.lsp.buf.format({ async = true })
            end
        end, opts)
    end,
})
