-- dotfiles/nvim/lua/plugins/treesitter.lua
-- treesitterによるシンタックスハイライト・パーサー管理

return {
    {
        'nvim-treesitter/nvim-treesitter',
        branch = 'master',
        build = ':TSUpdate',
        opts = {
            ensure_installed = {
                'lua', 'vim', 'vimdoc', 'query',
                'python', 'javascript', 'typescript', 'tsx',
                'rust', 'go', 'markdown', 'markdown_inline',
                'powershell',
            },
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
        },
        config = function(_, opts)
            require('nvim-treesitter.configs').setup(opts)
        end,
    },
}
