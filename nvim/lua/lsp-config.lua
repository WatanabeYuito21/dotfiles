-- ~/.config/nvim/lua/lsp-config.lua
-- local lspconfig = require('lspconfig')

-- nvim-cmpとの連携
local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if cmp_nvim_lsp_ok then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

-- conform.nvim のチェック
local conform_ok, conform = pcall(require, 'conform')

-- LSPサーバーの設定（手動で各サーバーを設定）
-- Lua
if vim.fn.executable('lua-language-server') == 1 then
    vim.lsp.config.lua_ls = {
        capabilities = capabilities,
        settings = {
            Lua = {
                diagnostics = {
                    globals = { 'vim' },
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                },
            },
        },
    }
end

-- Python
if vim.fn.executable('pyright') == 1 or vim.fn.executable('pyright-langserver') == 1 then
    vim.lsp.config.pyright = {
        capabilities = capabilities,
    }
end

-- TypeScript/JavaScript
if vim.fn.executable('typescript-language-server') == 1 then
    vim.lsp.config.ts_ls = {
        capabilities = capabilities,
    }
end

-- Rust
if vim.fn.executable('rust-analyzer') == 1 then
    vim.lsp.config.rust_analyzer = {
        capabilities = capabilities,
        settings = {
            ['rust-analyzer'] = {
                checkOnSave = {
                    command = "clippy",
                },
                cargo = {
                    allFeatures = true,
                },
                procMacro = {
                    enable = true,
                },
            },
        },
    }
end

-- Go
if vim.fn.executable('gopls') == 1 then
    vim.lsp.config.gopls = {
        capabilities = capabilities,
    }
end

-- PowerShell
if vim.fn.executable('pwsh') == 1 then
    vim.lsp.config.powershell_es = {
        capabilities = capabilities,
    }
end

-- Markdown
if vim.fn.executable('marksman') == 1 then
    vim.lsp.config.marksman = {
        capabilities = capabilities,
    }
end

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
        vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

        -- 診断機能
        vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

        -- フォーマット（conform.nvim を優先、フォールバックでLSP）
        vim.keymap.set('n', '<space>f', function()
            if conform_ok then
                conform.format({ async = true, lsp_fallback = true })
            else
                vim.lsp.buf.format { async = true }
            end
        end, opts)
    end,
})
