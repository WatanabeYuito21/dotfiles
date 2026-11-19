-- dotfiles/nvim/lua/plugins/markdown.lua
-- -- Markdown関連のプラグイン設定

return {
    {
        'iamcco/markdown-preview.nvim',
        cmd = {
            'MarkdownPreview',
            'MarkdownPreviewStop',
            'MarkdownPreviewToggle',
        },
        ft = { 'markdown' },
        keys = {
            { '<Leader>mp', '<cmd>MarkdownPreviewToggle<cr>', ft = 'markdown', desc = 'Markdown Preview Toggle' },
        },
        build = function()
            -- 遅延ロードのためビルド時は未ロード。先にロードしてから mkdp#util#install を呼ぶ
            require('lazy').load({ plugins = { 'markdown-preview.nvim' } })
            vim.fn['mkdp#util#install']()
        end,
        init = function()
            vim.g.mkdp_filetypes = { 'markdown' }
        end,
    },
    {
        -- バッファ内でMarkdownを整形表示（見出し・表・コードブロック等）
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'nvim-tree/nvim-web-devicons',
        },
        ft = { 'markdown' },
        opts = {
            -- 補完（チェックボックス・コールアウト）はプラグイン内蔵の LSP 経由にする。
            -- 既定の nvim-cmp 連携だと .md を開いた時点で nvim-cmp と LuaSnip が連鎖ロードされる。
            -- 内蔵 LSP は cmp-nvim-lsp の nvim_lsp ソース経由で、これまでどおり nvim-cmp の候補に出る
            completions = { lsp = { enabled = true } },
        },
    },
}
