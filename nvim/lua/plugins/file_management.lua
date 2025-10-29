-- dotfiles/nvim/lua/plugins/file_management.lua
-- -- ファイル管理関連のプラグイン設定

return {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons',
        'MunifTanjim/nui.nvim',
    },
    opts = {
        filesystem = {
            follow_current_file = { enabled = true },
            use_libuv_file_watcher = true,
            filtered_items = {
                hide_dotfiles = false,
                visible = true,
                hide_gitignored = false,
            },
        },
    },
}
