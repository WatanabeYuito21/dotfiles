-- ~/.config/nvim/lua/keymaps.lua
local map = vim.keymap.set

map('i', 'jj', '<ESC>', { noremap = true, silent = true })
map('n', '<ESC><ESC>', ':nohl<CR>', { silent = true })
map('n', 'Y', 'y$', { noremap = true, silent = true })
map('t', 'jj', [[<C-\><C-n>]], { noremap = true, silent = true })
