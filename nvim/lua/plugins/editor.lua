-- dotfiles/nvim/lua/plugins/editor.lua
-- -- エディタ関連のプラグイン設定

return {
    {
        -- コメントアウトを簡単にするプラグイン
        'numToStr/Comment.nvim',
        opts = {},
    },
    {
        -- コードの折りたたみを強化するプラグイン
        'Wansmer/treesj',
        keys = {
            '<space>m',
            '<space>j',
            '<space>s',
        },
    },
    {
        -- メモ帳プラグイン
        'glidenote/memolist.vim',
        cmd = {
            'MemoNew',
            'MemoList',
            'MemoGrep',
        },
        keys = {
            {'<Leader>mn', '<cmd>MemoNew<cr>', desc = 'New Memo'},
            {'<Leader>ml', '<cmd>MemoList<cr>', desc = 'List Memos'},
            {'<Leader>mg', '<cmd>MemoGrep<cr>', desc = 'Grep Memos'},
        },
        init = function()
            local memolist_path

            local is_wsl = vim.fn.filereadable('/proc/version') == 1 and vim.fn.readfile('/proc/version')[1]:match('microsoft') ~=nil

            if is_wsl or vim.fn.has('unix') == 1 then
                memolist_path = vim.fn.expand('~/Documents/memolist')
            elseif vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
                memolist_path = vim.fn.expand('~/Documents/memolist')
            else
                memolist_path = vim.fn.expand('~/Documents/memolist')
            end

            if vim.fn.isdirectory(memolist_path) == 0 then
                vim.fn.mkdir(memolist_path, 'p')
            end

            vim.g.memolist_path = memolist_path
            vim.g.memolist_memo_suffix = 'txt'
            vim.g.memolist_memo_date = '%Y%m%d_%H:%M'
            vim.g.memolist_filename_prefix_none = 0
            vim.g.memolist_template_dir_path = vim.fn.expand('~/.config/nvim/templates')
            vim.g.memolist_memo_list_height = 15
            vim.g.memolist_ex_cmd = 'Neotree'
            vim.g.memolist_filename_date = '%Y%m%d_'
        end,
    },
}
