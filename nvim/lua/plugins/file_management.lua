-- dotfiles/nvim/lua/plugins/file_management.lua
-- -- ファイル管理関連のプラグイン設定

return {
    {
        'nvim-neo-tree/neo-tree.nvim',
        branch = 'v3.x',
        cmd = 'Neotree',
        init = function()
            -- nvim <ディレクトリ> で起動したときだけ読み込む（netrw の代替）
            vim.api.nvim_create_autocmd('BufEnter', {
                group = vim.api.nvim_create_augroup('dotfiles_neotree_start_directory', { clear = true }),
                once = true,
                callback = function()
                    if package.loaded['neo-tree'] then
                        return
                    end
                    local stat = vim.uv.fs_stat(vim.fn.argv(0) --[[@as string]])
                    if stat and stat.type == 'directory' then
                        require('neo-tree')
                    end
                end,
            })
        end,
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
                    visible = true,
                    hide_dotfiles = false,
                    hide_gitignored = false,
                    hide_ignored = false,
                    hide_hidden = false,
                    always_show_by_pattern = {"*"},
                },
            },
        },
    },
}
