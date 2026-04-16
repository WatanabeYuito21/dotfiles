# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## セットアップ

```bash
# Linux / WSL
./setup.sh                             # 全設定をセットアップ
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
.\setup.ps1 -SkipNvim -SkipPlugins

# Windows (コマンドプロンプト・管理者権限推奨)
setup.bat
```

`--only` と `--skip-*` は併用不可。対応コンポーネント: `nvim` `tmux` `bash` `wsl`。`--only nvim` は Lazy sync まで、`--only tmux` は TPM 初期化まで含めて実行される。

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
- `.bashrc` はシンボリックリンクのため、スクリプトから直接追記しない（リポジトリ本体が書き換わる）

### Neovim 設定 (`nvim/`)

`init.lua` が `options` → `keymaps` → `plugins.init` の順にロード。

```
nvim/lua/
├── options.lua          # エディタオプション
├── keymaps.lua          # グローバルキーマップ
├── plugins/
│   ├── init.lua         # lazy.nvim のブートストラップ・プラグイン一覧
│   ├── ui.lua           # lualine, hlchunk, neo-tree
│   ├── editor.lua       # Comment.nvim, treesj
│   ├── file_management.lua
│   ├── markdown.lua     # markdown-preview, memolist
│   ├── formatter.lua    # conform.nvim（保存時自動フォーマット）
│   ├── lsp.lua          # mason, nvim-cmp, LuaSnip
│   └── ai.lua           # claudecode.nvim
└── lsp/
    ├── init.lua         # LSP 全体の初期化
    ├── servers.lua      # 言語別サーバー設定（vim.lsp.config API）
    ├── handlers.lua     # diagnostics 表示・キーバインド設定
    └── capabilities.lua # nvim-cmp との連携
└── utils/
    └── init.lua         # 汎用ユーティリティ（拡張用プレースホルダー）
```

**新しい言語を追加する場合**:
1. `nvim/lua/lsp/servers.lua` に `vim.lsp.config.<server> = { capabilities = capabilities }` を追加
2. `nvim/lua/plugins/formatter.lua` の `formatters_by_ft` にフォーマッターを追加
3. Mason（`:Mason`）またはシステムパッケージマネージャーでツールをインストール

**プラグインを追加する場合**: `nvim/lua/plugins/init.lua` の lazy.nvim プラグインリストに追記し、設定が多い場合は対応する `*.lua` ファイル（`ui.lua`, `editor.lua` 等）に分割する。

### WSL設定 (`wsl/`)

- `wsl/wsl.conf` は `/etc/wsl.conf` へシンボリックリンクされる
- systemd 有効化・Windows PATH 汚染防止（`appendWindowsPath=false`）・ロケール設定を含む

### bash (`bash/bashrc`)

- pyenv・cargo・nvm・uv の PATH 設定と初期化が含まれている
- 複数ターミナル間での履歴共有（`PROMPT_COMMAND='share_history'`）
- WSL2 用の DISPLAY・LANG・interop 設定
- `~/.bashrc_im` を source している（IBus 入力メソッド設定、リポジトリ管理外）

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
