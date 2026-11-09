-- dotfiles/nvim/plugins/ai.lua

return {
    -- GitHub Copilot
    {
        "github/copilot.vim",
        event = "InsertEnter",
        cmd = "Copilot",
    },
    -- Claude Code
    {
        "coder/claudecode.nvim",
        dependencies = { "folke/snacks.nvim" },
        opts = {
            terminal = {
                snacks_win_opts = {
                    wo = {
                        fillchars = "eob: ,lastline:>",
                        listchars = "extends:>,tab:  ",
                        -- NormalFloat 経由の背景色を使わず、透過済みの Normal を使う
                        winhighlight = "Normal:Normal,NormalNC:NormalNC,WinBar:SnacksWinBar,WinBarNC:SnacksWinBarNC,WinSeparator:WinSeparator",
                    },
                    keys = {
                        -- terminal モードから抜けてそのまま <C-w> のウィンドウ操作に入る
                        win_nav = { "<C-w>", [[<C-\><C-n><C-w>]], mode = "t", desc = "Window command" },
                    },
                },
            },
        },
        keys = {
            { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
            { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
            { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
            { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
            { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select model" },
            { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
            { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
            { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
            { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
        },
    }
}
