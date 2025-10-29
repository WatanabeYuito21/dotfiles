-- dotfiles/nvim/lua/lsp/capabilities.lua
-- nvim-cmpとLSPの統合設定

local M = {}

-- nvim-cmpとの連携
local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if cmp_nvim_lsp_ok then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

return capabilities
