-- dotfiles/nvim/lua/plugins/lsp.lua
-- LSP関連のプラグイン設定

return {
    {
        -- LSPサーバー管理ツール
        -- 起動時には読まない。nvim-lspconfig の dependencies として BufReadPre で読まれ、
        -- そのとき setup() が PATH に mason/bin を足す（LSP の起動より先）
        'williamboman/mason.nvim',
        cmd = { 'Mason', 'MasonInstall', 'MasonUninstall', 'MasonUninstallAll', 'MasonLog', 'MasonUpdate' },
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
        -- スニペットエンジン（nvim-cmp の依存として InsertEnter で読み込む）
        'L3MON4D3/LuaSnip',
        lazy = true,
        build = 'make install_jsregexp',
    },
    {
        -- 補完エンジン
        'hrsh7th/nvim-cmp',
        event = { 'InsertEnter' },
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
        -- ensure_installed と :LspInstall 用。LSP の有効化は lsp/servers.lua なので UI 表示後でよい
        event = 'VeryLazy',
        cmd = { 'LspInstall', 'LspUninstall' },
        config = function()
            -- servers.lua と同じサーバーを自動インストールする。
            -- 必要なツールチェーンがない環境ではエラー通知を避けるため対象から外す。
            -- lsp/servers.lua と同じコマンドを調べるので、PATH 検索の結果は共有する
            local has = require('exe_cache').executable
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
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            -- mason は PATH 設定のために lspconfig より先に読み込む
            'williamboman/mason.nvim',
            -- mason-lspconfig と nvim-cmp は依存から外す（それぞれ VeryLazy / InsertEnter で読む）
        },
        config = function()
            require('lsp')
        end,
    },
}
