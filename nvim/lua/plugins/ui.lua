-- dotfiles/nvim/lua/plugins/ui.lua
-- UI関連のプラグイン設定

return {
    {
        -- ステータスライン表示
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {
            options = {
                theme = 'auto',
            },
            sections = {
                lualine_x = {
                    {
                        function()
                            local enc = vim.bo.fileencoding ~= '' and vim.bo.fileencoding or vim.o.encoding
                            if vim.bo.bomb then
                                enc = enc .. ' [BOM]'
                            end
                            return enc
                        end,
                    },
                    'fileformat',
                    'filetype',
                },
            },
        },
    },
    {
        -- インデントガイド表示
        'shellRaining/hlchunk.nvim',
        event = {
            'BufReadPre',
            'BufNewFile',
        },
        opts = {
            indent = { enable = true },
            line_num = { enable = true },
            blank = { enable = true },
            chunk = { enable = false },
        },
    },
}
