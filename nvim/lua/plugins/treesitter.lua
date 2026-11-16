-- dotfiles/nvim/lua/plugins/treesitter.lua
-- treesitterによるシンタックスハイライト・パーサー管理
--
-- nvim-treesitter は main ブランチ（Neovim 0.12+ 対応の書き直し版）を使う。
-- main ではプラグインはパーサー/クエリのインストールのみを担当し、
-- ハイライト・インデントは FileType autocmd で自分で有効化する。
-- パーサーのインストールには tree-sitter CLI と C コンパイラが必要。

-- 起動時にインストールしておくパーサー
local ensure_installed = {
    'lua', 'vim', 'vimdoc', 'query',
    'python', 'javascript', 'typescript', 'tsx',
    'rust', 'go', 'markdown', 'markdown_inline',
    'powershell',
}

-- パーサーのビルドに必要なツールのうち見つからないものを返す
local function missing_tools()
    local missing = {}
    -- Windows ではビルドのジョブが .exe を直接起動するため、npm 版が置く
    -- tree-sitter.cmd（中継スクリプト）は executable() では見つかっても起動できない。
    -- .exe 本体があるかで判定する
    local cli = vim.fn.has('win32') == 1 and 'tree-sitter.exe' or 'tree-sitter'
    if vim.fn.executable(cli) == 0 then
        if vim.fn.executable('tree-sitter') == 1 then
            table.insert(missing, 'tree-sitter CLI の exe（npm 版の .cmd は使えないため cargo install tree-sitter-cli 等で入れる）')
        else
            table.insert(missing, 'tree-sitter CLI')
        end
    end
    local has_cc = vim.iter({ 'cc', 'gcc', 'clang', 'cl', 'zig' }):any(function(c)
        return vim.fn.executable(c) == 1
    end)
    if not has_cc then
        table.insert(missing, 'C コンパイラ')
    end
    return missing
end

return {
    {
        'nvim-treesitter/nvim-treesitter',
        branch = 'main',
        lazy = false, -- main ブランチは遅延ロード非対応
        build = ':TSUpdate',
        config = function()
            local ts = require('nvim-treesitter')
            -- lazy.nvim の rtp リセットで既定の stdpath('data')/site が runtimepath から外れるため、
            -- install_dir を明示して runtimepath に追加させる
            ts.setup({ install_dir = vim.fn.stdpath('data') .. '/site' })

            -- ツールが無い環境では FileType ごとにインストールが失敗し続けるため、
            -- 自動インストールを止めて一度だけ警告する
            -- （ハイライトは導入済みパーサーと Neovim 同梱パーサーで動く）
            local missing = missing_tools()
            local can_install = #missing == 0
            if can_install then
                ts.install(ensure_installed)
            else
                vim.schedule(function()
                    vim.notify(
                        '[treesitter] ' .. table.concat(missing, ' / ')
                            .. ' が見つからないためパーサーの自動インストールを無効化しました',
                        vim.log.levels.WARN
                    )
                end)
            end

            local available = can_install and ts.get_available() or {}

            local function enable(buf, lang)
                -- パーサーが無い言語では start がエラーになるので pcall で握りつぶす
                if not pcall(vim.treesitter.start, buf, lang) then
                    return
                end
                vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end

            vim.api.nvim_create_autocmd('FileType', {
                group = vim.api.nvim_create_augroup('dotfiles_treesitter', { clear = true }),
                callback = function(args)
                    local lang = vim.treesitter.language.get_lang(args.match)
                    if not lang then
                        return
                    end
                    -- 旧 auto_install 相当: 未導入だがインストール可能な言語は入れてから有効化
                    if not vim.treesitter.language.add(lang) and vim.list_contains(available, lang) then
                        ts.install(lang):await(vim.schedule_wrap(function(err)
                            if not err and vim.api.nvim_buf_is_valid(args.buf) then
                                enable(args.buf, lang)
                            end
                        end))
                        return
                    end
                    enable(args.buf, lang)
                end,
            })
        end,
    },
}
