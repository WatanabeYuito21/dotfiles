# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## セットアップ

```bash
# Linux / WSL
./setup.sh                             # 未指定時はコンポーネントを対話的に選択
./setup.sh --skip-wsl                  # WSL設定をスキップ
./setup.sh --skip-nvim --skip-tmux --skip-bash

# 特定コンポーネントのみ実行（カンマ区切りまたは繰り返し指定）
./setup.sh --only nvim
./setup.sh --only=nvim,tmux
./setup.sh --only nvim --only tmux

# 状態を変更せず実行内容のみ確認
./setup.sh --dry-run
./setup.sh --only nvim --dry-run

# Windows (PowerShell)
.\setup.ps1
.\setup.ps1 -DryRun
.\setup.ps1 -Only nvim
.\setup.ps1 -Only nvim,wsl -DryRun
.\setup.ps1 -SkipNvim -SkipPlugins
.\setup.ps1 -SkipWSL

# Windows (コマンドプロンプト・管理者権限推奨)
setup.bat
setup.bat --dry-run
setup.bat --only nvim
setup.bat --only nvim,wsl --dry-run
setup.bat --skip-nvim
setup.bat --skip-wsl
```

`--only` と `--skip-*` は併用不可。Linux/WSL の対応コンポーネント: `nvim` `tmux` `bash` `wsl`。Windows の対応コンポーネント: `nvim` `wsl`。`--only nvim` は Lazy sync まで含めて実行される。

`--only` / `--skip-*`（PowerShell は `-Only` / `-Skip*`）のいずれも指定しない場合、対話的にコンポーネントを選択するプロンプトが表示される（番号入力・`a`・空 Enter で全選択）。非対話環境（パイプ実行など）では従来通り全コンポーネントをインストールする。`--dry-run` は選択指定とはみなされないため、単独指定でもプロンプトが表示される。

WSL設定を適用した後は WSL を再起動する必要がある（`wsl --shutdown`）。

スクリプトを新規追加した場合は実行権限を付与:
```bash
chmod +x setup.sh
find scripts/ -name "*.sh" -exec chmod +x {} \;
```

Windows から WSL にコピーした .sh ファイルは改行コードに注意（`dos2unix` で変換）。

## アーキテクチャ

### セットアップスクリプト (`scripts/`)

エントリーポイントは `setup.sh`（root）→ `scripts/setup.sh` に移譲する構造。

```
scripts/
├── lib/
│   ├── logger.sh      # log_info / log_warn / log_error / log_step
│   ├── backup.sh      # backup_if_exists（タイムスタンプ付きリネーム）
│   └── utils.sh       # is_wsl, run_cmd（dry-run対応）, setup_config, setup_home_config
├── installers/
│   ├── deps.sh        # check_dependencies（nvim・git は必須、他はオプション）
│   ├── nvim.sh        # setup_neovim, setup_lazy
│   ├── tmux.sh        # setup_tmux, setup_tpm
│   ├── bash.sh        # setup_bash
│   └── wsl.sh         # setup_wsl
└── post-install/
    └── recommendations.sh # show_recommendations
```

- `DOTFILES_DIR` は `scripts/setup.sh` 内で `BASH_SOURCE` から自動決定（ハードコードしない）
- `setup_config "nvim"` は `$DOTFILES_DIR/nvim` → `~/.config/nvim` へシンボリックリンクを作成
- `setup_home_config` はホームディレクトリへのファイルリンク用
- state を変更するシェル操作（`rm` / `mkdir` / `ln` / `mv` / `cp` / `git clone` / `nvim --headless`）は `run_cmd` 経由で呼ぶこと。`DRY_RUN=true` 時は実行せずログ出力に切り替わる
- 非致命的なステップ（オプション依存、WSL設定など）は失敗しても `return 0` で続行する
- `setup_lazy` の `nvim --headless "+Lazy! sync"` は出力を一時ログに保存し、失敗時のみログのパスと末尾10行を表示する（dry-run 時はコマンド表示のみ）
- `.bashrc` はシンボリックリンクのため、スクリプトから直接追記しない（リポジトリ本体が書き換わる）
- CI（`.github/workflows/ci.yml`）で shellcheck（`scripts/`・`setup.sh`・`wsl/apply-wsl-config.sh` は style レベル、`bash/` は warning レベルで SC1090/SC2155 を除外）と `./setup.sh --dry-run` を実行する。手元では `uvx --from shellcheck-py shellcheck -x -P SCRIPTDIR -S style <files>` で確認できる

### Neovim 設定 (`nvim/`)

`init.lua` が `options` → `keymaps` → `plugins.init` の順にロード。

```
nvim/lua/
├── options.lua          # エディタオプション
├── keymaps.lua          # グローバルキーマップ
├── plugins/
│   ├── init.lua         # lazy.nvim のブートストラップ・プラグイン一覧
│   ├── ui.lua           # lualine, hlchunk, neo-tree
│   ├── treesitter.lua   # nvim-treesitter（パーサー管理・シンタックスハイライト）
│   ├── editor.lua       # Comment.nvim, treesj
│   ├── file_management.lua
│   ├── markdown.lua     # markdown-preview, memolist
│   ├── formatter.lua    # conform.nvim（保存時自動フォーマット）
│   ├── lsp.lua          # mason, mason-lspconfig（ensure_installed）, lazydev, nvim-cmp, LuaSnip
│   └── ai.lua           # claudecode.nvim, copilot.vim
└── lsp/
    ├── init.lua         # LSP 全体の初期化
    ├── servers.lua      # 言語別サーバー設定（vim.lsp.config API）
    ├── handlers.lua     # diagnostics 表示・キーバインド設定
    └── capabilities.lua # nvim-cmp との連携
```

**新しい言語を追加する場合**:
1. `nvim/lua/lsp/servers.lua` に `vim.lsp.config.<server> = { capabilities = capabilities }` を追加
2. `nvim/lua/plugins/formatter.lua` の `formatters_by_ft` にフォーマッターを追加
3. `nvim/lua/plugins/treesitter.lua` の `ensure_installed` に treesitter パーサー名を追加（未対応だと Comment.nvim 等 treesitter 依存機能が `[Comment.nvim] nil` のようなエラーになる）
4. Mason を使う場合は `nvim/lua/plugins/lsp.lua` の mason-lspconfig `ensure_installed` に lspconfig 名を追加する（自動有効化は `automatic_enable = false` のため、有効化は手順1の `servers.lua` のみで行われる）。システムパッケージマネージャーで入れる場合は `:Mason` または各パッケージマネージャーでインストール

- `nvim/lazy-lock.json` はコミット対象（プラグイン版の固定）。`:Lazy update` 後は差分をコミットし、他マシンでは `:Lazy restore` で揃える
- mason-lspconfig の `ensure_installed` は headless 起動では実行されない。`setup.sh` の Lazy sync では LSP サーバーは入らず、初回の通常起動時にインストールされる
- `nvim/lua/lsp/*.lua`・`nvim/lua/plugins/{editor,file_management,formatter,init,lsp,markdown,ui}.lua`は CRLF 改行。スクリプトで編集するときは改行を LF に変換しないこと（全行が差分になる）

**プラグインを追加する場合**: `nvim/lua/plugins/init.lua` の lazy.nvim プラグインリストに追記し、設定が多い場合は対応する `*.lua` ファイル（`ui.lua`, `editor.lua` 等）に分割する。

**GitHub Copilot**: `github/copilot.vim` は `nvim/lua/plugins/ai.lua` の lazy.nvim 管理（`InsertEnter` / `:Copilot` で遅延ロード）。更新は `:Lazy update`。初回は `:Copilot setup` で認証する。

### WSL設定 (`wsl/`)

- `wsl/wsl.conf` は `~/.wsl/wsl.conf` にコピーされる。`/etc/wsl.conf` への反映は手動で `sudo cp ~/.wsl/wsl.conf /etc/wsl.conf` を実行する（root 所有ファイルのためシンボリックリンク不可）
- systemd 有効化・Windows PATH 汚染防止（`appendWindowsPath=false`）・ロケール設定を含む
- `wsl/apply-wsl-config.sh` も `~/.wsl/apply-wsl-config.sh` にコピーされ（実行権限付き）、`sudo` で実行すると `/etc/wsl.conf` をバックアップしたうえで配置する。bash 側のエイリアス `apply-wsl-config` から呼べる
- `appendWindowsPath=false` により Windows 側の実行ファイル（例: `pwsh.exe`）は WSL から見えない。PowerShell LSP (`powershell_es`) を使う場合は WSL 内にネイティブの `pwsh` を別途インストールする必要がある

### bash (`bash/bashrc`)

- `bash/bashrc` 本体は Ubuntu 標準設定・履歴共有（`PROMPT_COMMAND='share_history'`）・LANG 設定のみ。残りは `bash/conf.d/*.sh` に分割されており、番号順に source される（WSL/DISPLAY・pyenv・cargo・nvm・uv・IBus・shogun・smart-run）
- 読み込み元の解決は `readlink -f "${BASH_SOURCE[0]}"`（`~/.bashrc` はシンボリックリンクのため）。新しい設定は `conf.d/` に `NN-name.sh` として追加する
- `bash/local/<hostname -s>.bashrc` が最後に source される（ホスト固有設定）
- `~/.bashrc_im` を source している（IBus 入力メソッド設定、リポジトリ管理外）
- `~/.wsl/apply-wsl-config.sh`（`wsl/` から配置）が存在する場合のみ `apply-wsl-config` エイリアスが定義される

### tmux (`tmux/tmux.conf`)

- プレフィックスキー: `Ctrl+j`
- TPM（Tmux Plugin Manager）でプラグイン管理
- プラグインは `~/.tmux/plugins/tpm/` にインストールされる（dotfiles 外）

## 対応言語・LSP

| 言語 | LSP | フォーマッター |
|---|---|---|
| Python | pyright | black + isort |
| TypeScript/JavaScript | ts_ls | prettier |
| Rust | rust-analyzer | rustfmt |
| Go | gopls | gofmt |
| Lua | lua_ls | stylua |
| PowerShell | PowerShell ES | prettier |
| Markdown | marksman | prettier |
