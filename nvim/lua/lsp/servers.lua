-- /dotfiles/nvim/lua/lsp/servers.lua
-- 各言語のLSPサーバー設定

local M = {}

-- Windows では Mason の bin/*.cmd 中継が、括弧を含むユーザーフォルダ（例: 渡邊唯人(ecbeing)）の
-- パスを cmd.exe に誤解釈されて起動できない。中継を介さず実体を直接起動する cmd を組み立てる。
-- 実体が見つからなければ nil を返し、その場合は lspconfig 既定の cmd（PATH 上のコマンド）に任せる。
local mason_packages = vim.fn.stdpath('data') .. '/mason/packages/'

-- 実行ファイル（.exe）を直接起動する cmd
local function mason_exe_cmd(relpath, args)
    local exe = mason_packages .. relpath
    if vim.fn.executable(exe) == 1 then
        return vim.list_extend({ exe }, args or {})
    end
end

-- node スクリプトを node.exe 経由で直接起動する cmd（npm の .cmd 中継の代わり）
local function mason_node_cmd(relpath, args)
    local script = mason_packages .. relpath
    local node = vim.fn.exepath('node')
    if node ~= '' and vim.fn.filereadable(script) == 1 then
        return vim.list_extend({ node, script }, args or {})
    end
end

function M.setup(capabilities)
    -- 有効にするサーバーのリスト
    local servers_to_enable = {}

    -- Lua言語サーバー設定
    -- （cmd が静的なサーバーは executable ガードを置かない。未導入なら vim.lsp.enable が起動を見送る）
    vim.lsp.config.lua_ls = {
        capabilities = capabilities,
        cmd = mason_exe_cmd('lua-language-server/bin/lua-language-server.exe'),
        settings = {
            Lua = {
                diagnostics = {
                    globals = {'vim'},
                },
                workspace = {
                    checkThirdParty = false,
                },
            },
        },
    }
    table.insert(servers_to_enable, 'lua_ls')

    -- Python言語サーバー設定
    vim.lsp.config.pyright = {
        capabilities = capabilities,
        cmd = mason_node_cmd('pyright/node_modules/pyright/langserver.index.js', { '--stdio' }),
    }
    table.insert(servers_to_enable, 'pyright')

    -- JavaScript/TypeScript言語サーバー設定
    vim.lsp.config.ts_ls = {
        capabilities = capabilities,
        cmd = mason_node_cmd('typescript-language-server/node_modules/typescript-language-server/lib/cli.mjs', { '--stdio' }),
    }
    table.insert(servers_to_enable, 'ts_ls')

    -- Rust言語サーバー設定
    vim.lsp.config.rust_analyzer = {
        capabilities = capabilities,
        cmd = mason_exe_cmd('rust-analyzer/rust-analyzer.exe'),
        settings = {
            ["rust-analyzer"] = {
                checkOnSave = true,
                check = {
                    command = "clippy",
                },
                cargo = {
                    allFeatures = true,
                },
                procMacro = {
                    enable = true,
                },
            },
        },
    }
    table.insert(servers_to_enable, 'rust_analyzer')

    -- Go言語サーバー設定
    vim.lsp.config.gopls = {
        capabilities = capabilities,
    }
    table.insert(servers_to_enable, 'gopls')

    -- PowerShell言語サーバー設定
    -- （cmd が関数になる設定のため validate_cmd が実行可否を見ない。pwsh のガードは残す）
    if vim.fn.executable('pwsh') == 1 then
        vim.lsp.config.powershell_es = {
            capabilities = capabilities,
            bundle_path = vim.fn.stdpath('data') .. '/mason/packages/powershell-editor-services',
        }
        table.insert(servers_to_enable, 'powershell_es')
    end

    -- Markdown言語サーバー設定
    -- Windows では Mason の marksman.cmd が、括弧を含むユーザーフォルダ（例: 渡邊唯人(ecbeing)）の
    -- パスを cmd.exe に誤解釈されて起動できないため、exe があれば直接指定する
    local marksman_exe = vim.fn.stdpath('data') .. '/mason/packages/marksman/marksman.exe'
    local marksman = vim.fn.executable(marksman_exe) == 1 and marksman_exe
        or (vim.fn.executable('marksman') == 1 and 'marksman')
    if marksman then
        vim.lsp.config.marksman = {
            capabilities = capabilities,
            cmd = { marksman, 'server' },
        }
        table.insert(servers_to_enable, 'marksman')
    end

    -- 設定したサーバーを有効化
    vim.lsp.enable(servers_to_enable)
end

return M
