-- ~/.config/nvim/lua/keymaps.lua
local map = vim.api.nvim_set_keymap
local opts_noremap = { noremap = true, silent = true }
local opts = { noremap = false, silent = true }

map('i', 'jj', '<ESC>', opts_noremap)
map('n', '<ESC><ESC>', ':nohl<CR>', opts)
map('n', 'Y', 'y$', opts_noremap)
map('t', 'jj', [[<C-\><C-n]], opts_noremap)
