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
        build = function()
            -- 遅延ロードのためビルド時は未ロード。先にロードしてから mkdp#util#install を呼ぶ
            require('lazy').load({ plugins = { 'markdown-preview.nvim' } })
            vim.fn['mkdp#util#install']()
        end,
        init = function()
            vim.g.mkdp_filetypes = { 'markdown' }
        end,
    },
}
