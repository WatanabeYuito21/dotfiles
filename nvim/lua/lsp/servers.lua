-- /dotfiles/nvim/lua/lsp/servers.lua
-- 各言語のLSPサーバー設定

local M = {}

function M.setup(capabilities)
    -- 有効にするサーバーのリスト
    local servers_to_enable = {}

    -- Lua言語サーバー設定
    if vim.fn.executable('lua-language-server') == 1 then
        vim.lsp.config.lua_ls = {
            capabilities = capabilities,
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
    end

    -- Python言語サーバー設定
    if vim.fn.executable('pyright') == 1 or vim.fn.executable('pyright-langserver') == 1 then
        vim.lsp.config.pyright = {
            capabilities = capabilities,
        }
        table.insert(servers_to_enable, 'pyright')
    end

    -- JavaScript/TypeScript言語サーバー設定
    if vim.fn.executable('typescript-language-server') == 1 then
        vim.lsp.config.ts_ls = {
            capabilities = capabilities,
        }
        table.insert(servers_to_enable, 'ts_ls')
    end

    -- Rust言語サーバー設定
    if vim.fn.executable('rust-analyzer') == 1 then
        vim.lsp.config.rust_analyzer = {
            capabilities = capabilities,
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
    end

    -- Go言語サーバー設定
    if vim.fn.executable('gopls') == 1 then
        vim.lsp.config.gopls = {
            capabilities = capabilities,
        }
        table.insert(servers_to_enable, 'gopls')
    end

    -- PowerShell言語サーバー設定
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
