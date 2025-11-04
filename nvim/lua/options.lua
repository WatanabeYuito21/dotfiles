-- ~/.config/nvim/lua/options.lua
local opt = vim.opt
local cmd = vim.cmd

-- python場所指定
local python_path = vim.fn.expand("~/.pyenv/shims/python3")
if vim.fn.executable(python_path) == 1 then
    vim.g.python3_host_prog = python_path
else
    -- fallback to system python
    vim.g.python3_host_prog = vim.fn.exepath("python3")
end
-- vim.g.python3_host_prog = "/.pyenv/bin/pyenv"

-- 行番号表示
opt.number = true

-- vimhelp表示言語
opt.helplang = { 'ja', 'en' }

-- 選択行表示
opt.cursorline = true

-- タブとインデント設定
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- encoding設定
opt.encoding = 'utf-8'
opt.fileencoding = 'utf-8'
opt.fileencodings = { 'ucs-boms', 'utf-8', 'enc-jp', 'cp932' }
opt.fileformats = { 'dos', 'unix', 'mac' }

-- 曖昧文字幅固定設定
opt.ambiwidth = 'double'

-- 制御文字表示設定
opt.list = true
opt.listchars = { tab = '>-', trail = '*', nbsp = '+' }

-- ビープ音を視覚表示に変更
opt.visualbell = true

-- 検索設定
opt.ignorecase = true
opt.smartcase = true

-- ファイルの自動読み直し設定
opt.autoread = true

-- バッファ編集中でもその他ファイルを開けるようにする設定
opt.hidden = true

-- 入力中コマンドをステータスに表示する設定
opt.showcmd = true

-- ステータスライン表示行数
opt.laststatus = 2

-- BackSpace Settings
opt.backspace = { 'indent', 'eol', 'start' }

-- 背景色設定
opt.background = 'dark'
-- opt.background = 'light'

-- クリップボード設定
opt.clipboard = "unnamedplus"

-- split,vsplit Settings
opt.splitbelow = true
opt.splitright = true

-- swapfile 出力無効化
-- cmd('set noswapfile')
opt.swapfile = false

-- Backupfile 出力無効化
-- cmd('set nobackup')
opt.backup = false

-- シンタックスハイライト有効化
cmd('syntax on')

-- カラースキーム設定
-- cmd('colorscheme spring-night')
cmd('colorscheme gruvbox')

-- 256色表示
cmd('set t_Co=256')

-- 透過設定
cmd('highlight Normal guibg=none')
cmd('highlight NonText guibg=none')
cmd('highlight Normal ctermbg=none')
cmd('highlight NonText ctermbg=none')
cmd('highlight NormalNC guibg=none')
cmd('highlight NormalSB ctermbg=none')

-- visual mode のハイライト設定
cmd('highlight visual guibg=#455354 guifg=none')
cmd('highlight visualNOS guibg=#455354 guifg=none')

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})
