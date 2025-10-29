-- dotfiles/nvim/lua/lsp/init.lua
-- LSP関連の設定エントリーポイント

-- capabilitiesの設定を読み込み
local capabilities = require('lsp.capabilities')

-- サーバー設定を読み込み
require('lsp.servers').setup(capabilities)

-- ハンドラーを読み込み
require('lsp.handlers')

