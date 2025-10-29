-- dotfiles/nvim/plugins/init.lua
-- プラグイン管理用の設定ファイル

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Global settings
vim.g.mkdp_auto_start = 1  -- Markdown Preview Auto Start
vim.g.mkdp_auto_close = 1  -- Markdown Preview Auto Close

-- Integrate plugins
local function get_all_plugins()
    local plugins = {}

    -- Load plugin configurations from the 'plugins' directory
    vim.list_extend(plugins, require('plugins.ui'))
    vim.list_extend(plugins, require('plugins.editor'))
    vim.list_extend(plugins, require('plugins.file_management'))
    vim.list_extend(plugins, require('plugins.markdown'))
    vim.list_extend(plugins, require('plugins.formatter'))
    vim.list_extend(plugins, require('plugins.lsp'))
    vim.list_extend(plugins, require('plugins.ai'))

    return plugins
end

-- Setup lazy.nvim with all plugins
require('lazy').setup(get_all_plugins(), {
    rocks = {
        enabled = true,
    },
})
