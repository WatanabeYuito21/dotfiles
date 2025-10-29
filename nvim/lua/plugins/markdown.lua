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
        build = 'cd app && yarn install',
        init = function()
            vim.g.mkdp_filetypes = { 'markdown' }
        end,
    },
}
