-- dotfiles/nvim/lua/plugins/ui.lua
-- UI関連のプラグイン設定

return {
    {
        -- ステータスライン表示
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {
            options = {
                theme = 'molokai',
            },
        },
    },
    {
        -- カラースキーム
        'shellRaining/hlchunk.nvim',
        event = {
            'BufReadPre',
            'BufNewFile',
        },
        opts = {
            indent = { enable = true },
            line_num = { enable = true },
            blank = { enable = true },
            chunk = { enable = true },
        },
    },
}
