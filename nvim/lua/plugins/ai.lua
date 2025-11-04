-- dotfiles/nvim/plugins/ai.lua
-- -- AI関連のプラグイン設定

return {
    {
        "yetone/avante.nvim",
        event = "VeryLazy",
        -- lazy = false,
        version = false,
        build = "make",
        opts = {
            provider = "copilot",
            providers = {
                copilot = {
                    endpoint = "https://api.githubcopilot.com",
                    model = "gpt-5-codex",
                    proxy = nil,
                    allow_insecure = false,
                    timeout = 30000,
                    temperature = 0,
                },
            },
            behavior = {
                auto_suggestions = false,
                auto_set_highlight_group = true,
                auto_set_keymaps = true,
                auto_apply_diff_after_generation = false,
                support_paste_from_clipboard = true,
                minimize_diff = true,
            },
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
            "zbirenbaum/copilot.lua",
            'nvim-lua/plenary.nvim',
        },
        ops = {
            model = "claude-4.5-sonnet",
            debug = true,
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
        config = function()
            require("copilot").setup({
                panel = {
                    enabled = true,
                    auto_refresh = false,
                    keymap = {
                        jump_prev = "[[",
                        jump_next = "]]",
                        accept = "<CR>",
                        refresh = "gr",
                        open = "<M-CR>"
                    },
                    layout = {
                        position = "bottom",
                        ratio = 0.4
                    },
                },
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    debounce = 75,
                    keymap = {
                        accept = "<C-J>",
                        accept_word = "<C-L>",
                        accept_line = false,
                        next = "<C-N>",
                        prev = "<C-K>",
                        dismiss = "<C-D>",
                    },
                },
                filetypes = {
                    yaml = false,
                    markdown = false,
                    help = false,
                    gitcommit = false,
                    gitrebase = false,
                    hgcommit = false,
                    svn = false,
                    cvs = false,
                    ["."] = false,
                },
                copilot_node_command = 'node',
                server_opts_overrides = {},
            })
        end,
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
