-- dotfiles/nvim/lua/plugins/lsp.lua
-- LSP関連のプラグイン設定

return {
    {
        -- LSPサーバー管理ツール
        'williamboman/mason.nvim',
        config = function()
            require('mason').setup()
        end,
    },
    {
        -- Neovim Lua API の型定義を lua_ls に必要な時だけ読み込ませる
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {},
    },
    {
        -- スニペットエンジン
        'L3MON4D3/LuaSnip',
        build = 'make install_jsregexp',
    },
    {
        -- 補完エンジン
        'hrsh7th/nvim-cmp',
        dependencies  = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
        },
        config = function()
            local cmp = require('cmp')
            local luasnip = require('luasnip')

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                }),
                sources = cmp.config.sources({
                    {name = 'nvim_lsp'},
                    {name = 'luasnip'},
                }, {
                    {name = 'buffer'},
                    {name = 'path'},
                }),
            })
        end,
    },

    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = { 'williamboman/mason.nvim' },
        config = function()
            -- servers.lua と同じサーバーを自動インストールする。
            -- 必要なツールチェーンがない環境ではエラー通知を避けるため対象から外す。
            local function has(cmd) return vim.fn.executable(cmd) == 1 end
            local ensure_installed = { 'lua_ls', 'rust_analyzer', 'marksman' }
            if has('npm') then vim.list_extend(ensure_installed, { 'pyright', 'ts_ls' }) end
            if has('go') then table.insert(ensure_installed, 'gopls') end
            if has('pwsh') then table.insert(ensure_installed, 'powershell_es') end

            require('mason-lspconfig').setup({
                ensure_installed = ensure_installed,
                -- サーバーの有効化は lsp/servers.lua に一本化する
                automatic_enable = false,
            })
        end,
    },

    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'hrsh7th/nvim-cmp',
        },
        config = function()
            require('lsp')
        end,
    },
}
