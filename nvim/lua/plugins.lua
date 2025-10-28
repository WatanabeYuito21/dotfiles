-- ~/.config/nvim/lua/plugins.lua
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git', 'clone', '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Global settings
vim.g.mkdp_auto_start = 1
vim.g.mkdp_auto_close = 1

local M = {}

-- Utility function to merge configs
local function merge_config(plugin_spec, config)
    if config then
        return vim.tbl_deep_extend("force", plugin_spec, config)
    end
    return plugin_spec
end

-- UI関連プラグイン
M.ui_plugins = {
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {
            options = {
                theme = 'molokai'
            }
        },
    },
    {
        'shellRaining/hlchunk.nvim',
        event = {
            'BufReadPre',
            'BufNewFile'
        },
        opts = {
            indent = { enable = true },
            line_num = { enable = true },
            blank = { enable = true },
            chunk = { enable = true },
        },
    },
}

-- エディタ機能プラグイン
M.editor_plugins = {
    {
        'numToStr/Comment.nvim',
        opts = {}
    },
    {
        'Wansmer/treesj',
        keys = {
            '<space>m',
            '<space>j',
            '<space>s'
        },
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        opts = {}
    },
    {
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

-- ファイル管理プラグイン
M.file_plugins = {
    {
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
                    hide_gitignored = false
                }
            },
        },
    },
}

-- Markdownプラグイン
M.markdown_plugins = {
    {
        'iamcco/markdown-preview.nvim',
        cmd = {
            'MarkdownPreviewToggle',
            'MarkdownPreview',
            'MarkdownPreviewStop'
        },
        ft = { 'markdown' },
        build = 'cd app && yarn install',
        init = function()
            vim.g.mkdp_filetypes = { 'markdown' }
        end,
    },
}

M.formatter_plugins = {
    {
        'stevearc/conform.nvim',
        event = { 'BufWritePre' },
        cmd = { 'ConformInfo' },
        config = function()
            require('conform-config')
        end,
    },
}

--- Copilot関連
M.ai_plugins = {
    {
        "yetone/avante.nvim",
        event = "VeryLazy",
        lazy = false,
        version = false,
        build = "make",
        opts = {
            provider = "copilot",
        },
        dependencies = {
            -- 必須の依存関係
            "stevearc/dressing.nvim",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            -- オプションの依存関係
            "hrsh7th/nvim-cmp",
            "nvim-tree/nvim-web-devicons",
            "zbirenbaum/copilot.lua",
            {
                -- image貼り付けサポート
                "HakonHarnes/img-clip.nvim",
                event = "VeryLazy",
                opts = {
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = {
                            insert_mode = true,
                        },
                        use_absolute_path = true,
                    },
                },
            },
            {
                -- markdown用のレンダリング
                "MeanderingProgrammer/render-markdown.nvim",
                opts = {
                    file_types = {"markdown", "Avante"},
                },
                ft = {"markdown", "Avante"},
            },
        },
    },

    -- Copilot Chat
    {
        'CopilotC-Nvim/CopilotChat.nvim',
        branch = 'main',
        dependencies = {
            'github/copilot.vim',
            'nvim-lua/plenary.nvim',
        },
        config = function()
            require('CopilotChat').setup({
                debug = false, -- デバッグモード
                show_help = 'yes',

                -- プロンプト設定
                prompts = {
                    Explain = {
                        prompt = '/COPILOT_EXPLAIN 選択されたコードを日本語で説明してください',
                        mapping = '<leader>ce',
                        description = 'コードの説明',
                    },
                    Review = {
                        prompt = '/COPILOT_REVIEW 選択されたコードをレビューし、改善提案を日本語でしてください',
                        mapping = '<leader>cr',
                        description = 'コードレビュー',
                    },
                    Fix = {
                        prompt = '/COPILOT_GENERATE このコードにバグがある場合は修正してください',
                        mapping = '<leader>cf',
                        description = 'バグ修正',
                    },
                    Optimize = {
                        prompt = '/COPILOT_GENERATE このコードを最適化してください',
                        mapping = '<leader>co',
                        description = 'コード最適化',
                    },
                    Docs = {
                        prompt = '/COPILOT_GENERATE 選択されたコードに適切なドキュメントコメントを追加してください',
                        mapping = '<leader>cd',
                        description = 'ドキュメント生成',
                    },
                    Tests = {
                        prompt = '/COPILOT_GENERATE 選択されたコードのテストケースを生成してください',
                        mapping = '<leader>ct',
                        description = 'テスト生成',
                    },
                },

                -- 自動トリガー設定
                auto_follow_cursor = false,
                auto_insert_mode = false,
                clear_chat_on_new_prompt = false,

                -- ウィンドウ設定
                window = {
                    layout = 'float', -- 'vertical', 'horizontal', 'float'
                    width = 80,
                    height = 20,
                    relative = 'editor',
                    border = 'rounded', -- 'single', 'double', 'rounded', 'solid'
                },
            })
        end,
        keys = {
            -- チャット関連
            {
                '<leader>cc',
                '<cmd>CopilotChat<cr>',
                desc = 'Copilot Chat を開く',
            },
            {
                '<leader>ccq',
                function()
                    local input = vim.fn.input('Quick Chat: ')
                    if input ~= '' then
                        require('CopilotChat').ask(input, { selection = require('CopilotChat.select').buffer })
                    end
                end,
                desc = 'クイックチャット',
            },
            {
                '<leader>cch',
                '<cmd>CopilotChatHistory<cr>',
                desc = 'チャット履歴',
            },
            {
                '<leader>ccr',
                '<cmd>CopilotChatReset<cr>',
                desc = 'チャットリセット',
            },

            -- 選択範囲でのチャット
            {
                '<leader>ccv',
                ':<C-u>CopilotChatVisual<cr>',
                mode = 'v',
                desc = '選択範囲でチャット',
            },
            {
                '<leader>ccx',
                -- ':<C-u>CopilotChatInPlace<cr>',
                function()
                    local input = vim.fn.input('選択範囲を修正：')
                    if input ~= '' then
                        require('CopilotChat').ask(input, {
                            selection = require('CopilotChat.select').visual
                        })
                    end
                end,
                mode = 'v',
                desc = 'インプレース編集',
            },
        },
    },

    -- copilot.lua(avante.nvimが依存)
    {
        "zbirenbaum/copilot.lua",
        -- cmd = "Copilot",
        event = "InsertEnter",
        opts = {
            panel = {
                enabled = false,
            },
            suggestion = {
                auto_trigger = true,
                hide_during_completion = false,
            },
        },
        -- config = function()
        --     require("copilot").setup({
        --         suggestion = {
        --             enabled = true,
        --             auto_trigger = true,
        --             debounce = 75,
        --             keymap = {
        --                 accept = "<M-l>",
        --                 accept_word = false,
        --                 accept_line = false,
        --                 next = "<M-]>",
        --                 prev = "<M-[>",
        --                 dismiss = "<C-]>",
        --             },
        --         },
        --         panel = {
        --             enabled = true,
        --             auto_refresh = false,
        --             keymap = {
        --                 jump_prev = "[[",
        --                 jump_next = "]]",
        --                 accept = "<CR>",
        --                 refresh = "gr",
        --                 open = "<M-CR>"
        --             },
        --             layout = {
        --                 position = "bottom",
        --                 ratio = 0.4
        --             },
        --         },
        --         filetypes = {
        --             yaml = false,
        --             markdown = false,
        --             help = false,
        --             gitcommit = false,
        --             gitrebase = false,
        --             hgcommit = false,
        --             svn = false,
        --             cvs = false,
        --             ["."] = false,
        --         },
        --         copilot_node_command = 'node',
        --         server_opts_overrides = {},
        --     })
        -- end,
    },

    -- より高機能なAIアシスタント
    {
        'Exafunction/codeium.nvim',
        enabled = false, -- 必要に応じてtrueに変更
        dependencies = {
            'nvim-lua/plenary.nvim',
            'hrsh7th/nvim-cmp',
        },
        config = function()
            require('codeium').setup({
                enable_chat = true,
            })
        end,
    },
}

-- LSP関連プラグイン
M.lsp_plugins = {
    -- Mason: LSPサーバー管理
    {
        'williamboman/mason.nvim',
        config = function()
            require("mason").setup()
        end,
    },

    -- スニペットエンジン
    {
        'L3MON4D3/LuaSnip',
        build = "make install_jsregexp",
    },

    -- 自動補完
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
        },
        config = function()
            require('cmp-config')
        end,
    },

    -- LSP Configuration
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'hrsh7th/nvim-cmp',
        },
        config = function()
            require('lsp-config')
        end,
    },
}

-- 全プラグインを結合する関数
function M.get_plugins()
    local all_plugins = {}
    for _, category in pairs({
        M.ui_plugins,
        M.editor_plugins,
        M.file_plugins,
        M.markdown_plugins,
        M.formatter_plugins,
        M.ai_plugins,
        M.lsp_plugins,
    }) do
        vim.list_extend(all_plugins, category)
    end
    return all_plugins
end

-- プラグインをセットアップ
require('lazy').setup(M.get_plugins(), {
    rocks = {
        enabled = false, --luarocks機能の無効化
    },
})
