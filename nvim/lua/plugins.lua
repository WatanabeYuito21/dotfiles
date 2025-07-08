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
