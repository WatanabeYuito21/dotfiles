-- ~/.config/nvim/lua/keymaps.lua
local map = vim.api.nvim_set_keymap
local opts_noremap = { noremap = true, silent = true }
local opts = { noremap = false, silent = true }

map('i', 'jj', '<ESC>', opts_noremap)
map('n', '<ESC><ESC>', ':nohl<CR>', opts)
map('n', 'Y', 'y$', opts_noremap)
map('t', 'jj', [[<C-\><C-n]], opts_noremap)

-- Copilot関連のキーマップ
vim.keymap.set('n', '<leader>cpe', ':Copilot enable<CR>', { silent = true, desc = 'Enable Copilot' })
vim.keymap.set('n', '<leader>cpd', ':Copilot disable<CR>', { silent = true, desc = 'Disable Copilot' })
vim.keymap.set('n', '<leader>cps', ':Copilot status<CR>', { silent = true, desc = 'Copilot Status' })
