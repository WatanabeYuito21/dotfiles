-- dotfiles/nvim/lua/exe_cache.lua
-- PATH 検索（vim.fn.executable / vim.fn.exepath）の結果をセッション中キャッシュする
--
-- PATH 上に無いコマンドの検索は PATH の全エントリを走査するため、1回で 30ms 以上かかることがある。
-- 同じコマンド名を設定の複数箇所（lsp/servers.lua と plugins/lsp.lua など）で調べているので、
-- 結果を共有して2回目以降は検索しない。結果は nvim を起動している間だけ保持する
-- （起動後にツールを入れたときは nvim の再起動で反映される）。
--
-- Mason のパッケージ内の絶対パスのように、後から導入されて結果が変わりうるものには使わない。

local M = {}

local executable_cache = {}
local exepath_cache = {}

---コマンドが実行可能か（vim.fn.executable(name) == 1 と同じ）
---@param name string
---@return boolean
function M.executable(name)
    local cached = executable_cache[name]
    if cached == nil then
        cached = vim.fn.executable(name) == 1
        executable_cache[name] = cached
    end
    return cached
end

---コマンドのフルパス。見つからなければ空文字（vim.fn.exepath(name) と同じ）
---@param name string
---@return string
function M.exepath(name)
    local cached = exepath_cache[name]
    if cached == nil then
        cached = vim.fn.exepath(name)
        exepath_cache[name] = cached
    end
    return cached
end

return M
