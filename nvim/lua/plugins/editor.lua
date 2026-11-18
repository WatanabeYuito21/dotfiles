-- dotfiles/nvim/lua/plugins/editor.lua
-- -- エディタ関連のプラグイン設定

return {
    {
        -- Neovim 標準の gc / gcc に、tsx など埋め込み言語向けの commentstring 判定だけを足す
        'JoosepAlviste/nvim-ts-context-commentstring',
        lazy = true,
        init = function()
            local get_option = vim.filetype.get_option
            vim.filetype.get_option = function(filetype, option)
                return option == 'commentstring'
                    and require('ts_context_commentstring.internal').calculate_commentstring()
                    or get_option(filetype, option)
            end
        end,
        -- 標準の gc が commentstring を決めるので、CursorHold での自動更新は不要
        opts = { enable_autocmd = false },
    },
    {
        -- コードの折りたたみを強化するプラグイン
        'Wansmer/treesj',
       keys = {
           {
               '<space>m',
               function() require('treesj').toggle() end,
               desc = 'Toggle Split/Join',
           },
           {
               '<space>j',
               function() require('treesj').join() end,
               desc = 'Join code block',
           },
           {
               '<space>s',
               function() require('treesj').split() end,
               desc = 'Split code block',
           },
        },
        opts = {
            use_default_keymaps = false,
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
            local memolist_path = vim.fn.expand('~/Documents/memolist')

            if vim.fn.isdirectory(memolist_path) == 0 then
                vim.fn.mkdir(memolist_path, 'p')
            end

            vim.g.memolist_path = memolist_path
            vim.g.memolist_memo_suffix = 'md'
            vim.g.memolist_memo_date = '%Y%m%d_%H:%M'
            vim.g.memolist_filename_prefix_none = 0
            vim.g.memolist_template_dir_path = vim.fn.expand('~/.config/nvim/templates')
            vim.g.memolist_memo_list_height = 15
            -- vim.g.memolist_ex_cmd = 'Neotree'
            vim.g.memolist_ex_cmd = 'edit'
            vim.g.memolist_filename_date = '%Y%m%d_'
        end,
    },
}
