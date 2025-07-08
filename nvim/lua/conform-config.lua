-- ~/.config/nvim/lua/conform-config.lua
local conform = require('conform')

conform.setup({
    formatters_by_ft = {
        python = { "isort", "black" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        rust = { "rustfmt" },
        lua = { "stylua" },
        go = { "gofmt" },
        powershell = { "prettier" },
        markdown = { "prettier" },
    },

    -- 保存時に自動フォーマット（オプション）
    format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
    },

    -- カスタムフォーマッター設定
    formatters = {
        black = {
            args = { "--fast", "--quiet", "-" },
        },
        isort = {
            args = { "--profile", "black", "--quiet", "-" },
        },
    },
})

-- 手動フォーマット用のコマンドを作成
vim.api.nvim_create_user_command("Format", function(args)
    local range = nil
    if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
        }
    end
    conform.format({ async = true, lsp_fallback = true, range = range })
end, { range = true })
