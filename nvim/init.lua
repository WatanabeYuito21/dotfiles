-- PowerShell の nvim 関数で起動の高速化のために付けた LANG / LC_MESSAGES を、子プロセス（git・LSP・:terminal）に引き継がないよう消す。nvim 自身の言語は起動時に決まっているので影響しない（2026-11-19 追加）
vim.env.LANG = nil
vim.env.LC_MESSAGES = nil
vim.loader.enable()

-- 基本オプション設定
require('options')

-- キーマップの設定
require('keymaps')

-- プラグインの設定
require('plugins.init')

