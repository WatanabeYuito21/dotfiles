-- ~/.config/nvim/lua/keymaps.lua
local map = vim.api.nvim_set_keymap
local opts_noremap = { noremap = true, silent = true }
local opts = { noremap = false, silent = true }

map('i', 'jj', '<ESC>', opts_noremap)
map('n', '<ESC><ESC>', ':nohl<CR>', opts)
map('n', 'Y', 'y$', opts_noremap)
map('t', 'jj', [[<C-\><C-n]], opts_noremap)

-- -- Copilot関連のキーマップ
-- vim.keymap.set('n', '<leader>cpe', ':Copilot enable<CR>', { silent = true, desc = 'Enable Copilot' })
-- vim.keymap.set('n', '<leader>cpd', ':Copilot disable<CR>', { silent = true, desc = 'Disable Copilot' })
-- vim.keymap.set('n', '<leader>cps', ':Copilot status<CR>', { silent = true, desc = 'Copilot Status' })
--
-- -- Avante.nvim関連のキーマップ
-- vim.keymap.set('n', '<leader>Ca', ':AvanteAsk<CR>', { silent = true, desc = 'Avante Ask' })
-- vim.keymap.set('v', '<leader>Ca', ':AvanteAsk<CR>', { silent = true, desc = 'Avante Ask (Visual)' })
-- vim.keymap.set('n', '<leader>Cr', ':AvanteRefresh<CR>', { silent = true, desc = 'Avante Refresh' })
-- vim.keymap.set('n', '<leader>Ce', ':AvanteEdit<CR>', { silent = true, desc = 'Avante Edit' })
-- vim.keymap.set('n', '<leader>Ct', ':AvanteToggle<CR>', { silent = true, desc = 'Avante Toggle' })
-- vim.keymap.set('n', '<leader>Cf', ':AvanteFocus<CR>', { silent = true, desc = 'Avante Focus' })
