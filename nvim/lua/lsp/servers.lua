-- /dotfiles/nvim/lua/lsp/servers.lua
-- 各言語のLSPサーバー設定

local M = {}

function M.setup(capabilities)
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
                        library = vim.api.nvim_get_runtime_file("", true),
                        checkThirdParty = false,
                    },
                },
            },
        }
    end

    -- Python言語サーバー設定
    if vim.fn.executable('pyright') == 1 or vim.fn.executable('pyright-langserver') == 1 then
        vim.lsp.config.pyright = {
            capabilities = capabilities,
        }
    end

    -- JavaScript/TypeScript言語サーバー設定
    if vim.fn.executable('typescript-language-server') == 1 then
        vim.lsp.config.ts_ls = {
            capabilities = capabilities,
        }
    end

    -- Rust言語サーバー設定
    if vim.fn.executable('rust-analyzer') == 1 then
        vim.lsp.config.rust_analyzer = {
            capabilities = capabilities,
            settings = {
                ["rust-analyzer"] = {
                    checkOnSave = {
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
    end

    -- Go言語サーバー設定
    if vim.fn.executable('gopls') == 1 then
        vim.lsp.config.gopls = {
            capabilities = capabilities,
        }
    end

    -- PowerShell言語サーバー設定
    if vim.fn.executable('pwsh') == 1 then
        vim.lsp.config.powershell_es = {
            capabilities = capabilities,
        }
    end

    -- Markdown言語サーバー設定
    if vim.fn.executable('marksman') == 1 then
        vim.lsp.config.marksman = {
            capabilities = capabilities,
        }
    end
end

return M
