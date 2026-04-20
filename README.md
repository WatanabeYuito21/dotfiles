# WatanabeYuito's Dotfiles

🚀 **現代的な開発環境設定** - WSL2/Linux対応、日本語サポート付き

## ✨ 主な機能

- **🐚 Shell**: 共有履歴機能付きBash設定
- **🖥️ Terminal**: セッション永続化対応Tmux
- **✏️ Editor**: LSP・自動補完・AI支援付きNeovim
- **🤖 AI統合**: Claude Code (claudecode.nvim) によるNeovim内AI支援
- **📝 メモ機能**: memolist.vim によるテキストメモ管理
- **🏠 WSL2最適化**: Windows環境との完全統合
- **🌍 多言語対応**: Python, Rust, TypeScript, Go, Lua, PowerShell

## 📁 構成

```
dotfiles/
├── bash/
│   └── bashrc              # 強化されたBash設定
├── tmux/
│   └── tmux.conf           # プラグイン対応Tmux設定
├── nvim/
│   ├── init.lua            # Neovim エントリーポイント
│   ├── lua/
│   │   ├── options.lua     # エディタオプション
│   │   ├── keymaps.lua     # キーマッピング
│   │   ├── plugins/        # プラグイン設定（モジュール分割）
│   │   │   ├── init.lua    # lazy.nvimプラグイン管理
│   │   │   ├── ui.lua      # UI関連プラグイン
│   │   │   ├── editor.lua  # エディタ機能プラグイン
│   │   │   ├── file_management.lua # ファイル管理プラグイン
│   │   │   ├── markdown.lua # Markdown関連プラグイン
│   │   │   ├── formatter.lua # コードフォーマット設定
│   │   │   ├── lsp.lua     # LSPプラグイン設定
│   │   │   └── ai.lua      # AI関連プラグイン
│   │   ├── lsp/            # LSP設定（モジュール分割）
│   │   │   ├── init.lua    # LSPエントリーポイント
│   │   │   ├── servers.lua # サーバー設定
│   │   │   ├── handlers.lua # ハンドラー設定
│   │   │   └── capabilities.lua # 機能設定
│   │   └── utils/          # ユーティリティ
│   ├── colors/molokai.vim  # カラースキーム
│   └── templates/          # テンプレートファイル
│       └── md.txt          # メモテンプレート（suffix=md 用）
├── wsl/
│   └── wsl.conf            # WSL設定
├── scripts/
│   ├── installers/         # インストーラスクリプト群
│   ├── lib/                # ユーティリティライブラリ
│   └── post-install/       # インストール後処理
├── setup.sh                # Linux/WSLセットアップスクリプト
├── setup.ps1               # PowerShellセットアップスクリプト
└── setup.bat               # Windowsバッチセットアップスクリプト
```

## 🎯 特徴的な設定

### Bash設定

- **共有履歴**: 全ターミナル間でリアルタイムコマンド履歴共有
- **WSL2統合**: 自動interop修正・ディスプレイ設定
- **開発ツール統合**:
  - Python (pyenv)
  - Rust (cargo)
  - Node.js (nvm)
- **日本語環境**: UTF-8ロケール完全対応
- **便利なエイリアス**: WSL設定適用コマンドなど

### Tmux設定

- **プレフィックスキー**: `Ctrl+j` (デフォルトの`Ctrl+b`から変更)
- **Vimスタイルナビゲーション**: `hjkl`でペイン移動、`HJKL`でリサイズ
- **セッション永続化**: 自動保存・復元 (tmux-resurrect/continuum)
- **モダンUI**: カスタムステータスバー
- **マウス対応**: フル統合マウスサポート
- **プラグイン管理**: TPM (Tmux Plugin Manager)

### Neovim設定

#### プラグイン管理

- **lazy.nvim**: 高速起動・遅延読み込み対応

#### UI・表示

- **lualine.nvim**: モダンなステータスライン (autoテーマ)
- **hlchunk.nvim**: インデントガイド・行番号ハイライト表示
- **neo-tree.nvim**: ツリー形式ファイルエクスプローラー
- **molokai**: カラースキーム

#### エディタ機能

- **Comment.nvim**: 高速コメント切り替え
- **treesj**: 構造的な分割・結合機能
- **markdown-preview.nvim**: Markdownプレビュー機能
- **memolist.vim**: テキストメモ管理システム
  - `~/Documents/memolist`にメモを保存
  - Neo-treeと統合したリスト表示
  - タイムスタンプ付きファイル名

#### LSP・補完

- **nvim-lspconfig**: 多言語LSP対応（最新のvim.lsp.config APIを使用）
- **mason.nvim**: LSPサーバー自動管理
- **nvim-cmp**: 強力な自動補完エンジン
  - LSP補完
  - バッファ補完
  - パス補完
  - スニペット補完 (LuaSnip)

#### フォーマッター

- **conform.nvim**: 保存時自動フォーマット
  - 言語別フォーマッター設定
  - LSPフォールバック対応

#### AI支援

- **claudecode.nvim**: Claude Code をNeovim内から操作
  - Claude Codeトグル・フォーカス
  - セッション再開・継続
  - モデル選択
  - バッファ追加・選択範囲送信
  - インラインdiff受け入れ・拒否
  - 依存プラグイン: folke/snacks.nvim

### 対応言語・ツール

| 言語                  | LSP           | フォーマッター |
| --------------------- | ------------- | -------------- |
| Python                | pyright       | black + isort  |
| TypeScript/JavaScript | ts_ls         | prettier       |
| Rust                  | rust-analyzer | rustfmt        |
| Go                    | gopls         | gofmt          |
| Lua                   | lua_ls        | stylua         |
| PowerShell            | PowerShell ES | prettier       |
| Markdown              | marksman      | prettier       |

## 🔧 インストール

### Linux/macOS/WSL環境

```bash
# このリポジトリをクローン
git clone https://github.com/WatanabeYuito21/dotfiles.git ~/dotfiles

# セットアップスクリプトを実行
cd ~/dotfiles
chmod +x setup.sh
./setup.sh

# 変更内容を事前確認（dry-run）
./setup.sh --dry-run

# 特定コンポーネントのみ再セットアップ
./setup.sh --only nvim           # nvim のみ（Lazy sync 含む）
./setup.sh --only nvim,tmux      # nvim + tmux
./setup.sh --only bash --dry-run # bash のみ dry-run

# 対応コンポーネント: nvim / tmux / bash / wsl

# bash設定を反映
source ~/.bashrc

# Neovimを起動してプラグインの自動インストールを確認
nvim
```

### WSL設定の適用

WSLの場合、追加セットアップが必要です：

```bash
# エイリアスを使用（推奨）
apply-wsl-config

# または、スクリプトを直接実行
sudo ~/.wsl/apply-wsl-config.sh
```

設定適用後はWSLを再起動してください：

**PowerShell/コマンドプロンプトで実行：**

```cmd
wsl --shutdown
```

### Windows環境

#### PowerShell版（推奨）

```powershell
# このリポジトリをクローン
git clone https://github.com/WatanabeYuito21/dotfiles.git $env:USERPROFILE\dotfiles

# PowerShellセットアップスクリプトを実行
cd $env:USERPROFILE\dotfiles
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser  # 初回のみ
.\setup.ps1

# オプション指定例
.\setup.ps1 -DryRun                    # 実行内容の確認のみ
.\setup.ps1 -Only nvim                 # Neovim のみセットアップ
.\setup.ps1 -Only nvim,wsl -DryRun
.\setup.ps1 -SkipWSL                   # WSL セットアップをスキップ
.\setup.ps1 -Help                      # ヘルプ表示
```

#### バッチファイル版

```cmd
# リポジトリをクローン後、コマンドプロンプトを管理者として実行
cd %USERPROFILE%\dotfiles
setup.bat

# オプション指定例
setup.bat --dry-run                    # 実行内容の確認のみ
setup.bat --only nvim                  # Neovim のみセットアップ
setup.bat --only nvim,wsl --dry-run
setup.bat --skip-wsl                   # WSL セットアップをスキップ
setup.bat --help                       # ヘルプ表示
```

**注意**: Windowsでシンボリックリンクを作成するには管理者権限が必要です。対応コンポーネント: `nvim` `wsl`

## ⌨️ キーバインド

### Tmux

| キー            | 動作               |
| --------------- | ------------------ |
| `Ctrl+j`        | プレフィックスキー |
| `Prefix + r`    | 設定リロード       |
| `Prefix + \|`   | 水平分割           |
| `Prefix + -`    | 垂直分割           |
| `Prefix + hjkl` | ペイン移動         |
| `Prefix + HJKL` | ペインリサイズ     |
| `Prefix + v`    | コピーモード       |
| `Prefix + c`    | 新規ウィンドウ     |
| `Prefix + ^`    | 最後のウィンドウ   |
| `Prefix + C-l`  | 画面クリア         |

### Neovim - 基本

| キー         | 動作                       |
| ------------ | -------------------------- |
| `jj`         | インサートモード終了       |
| `<Esc><Esc>` | 検索ハイライト解除         |
| `Y`          | 行末までヤンク             |
| `<Space>m`   | treesj: 分割/結合トグル    |
| `<Space>j`   | treesj: コードブロック結合 |
| `<Space>s`   | treesj: コードブロック分割 |

### Neovim - LSP

| キー        | 動作               |
| ----------- | ------------------ |
| `<Space>f`  | コードフォーマット |
| `<Space>e`  | 診断表示           |
| `gd`        | 定義へジャンプ     |
| `gi`        | 実装へジャンプ     |
| `gr`        | 参照表示           |
| `K`         | ホバー情報         |
| `<C-k>`     | シグネチャヘルプ   |
| `<Space>rn` | リネーム           |
| `<Space>ca` | コードアクション   |
| `[d`        | 前の診断           |
| `]d`        | 次の診断           |

### Neovim - Claude Code (claudecode.nvim)

| キー          | 動作                     |
| ------------- | ------------------------ |
| `<Leader>ac`  | Claude Code トグル       |
| `<Leader>af`  | Claude Code フォーカス   |
| `<Leader>ar`  | セッション再開 (resume)  |
| `<Leader>aC`  | セッション継続 (continue)|
| `<Leader>am`  | モデル選択               |
| `<Leader>ab`  | 現在バッファを追加       |
| `<Leader>as`  | 選択範囲を送信 (V)       |
| `<Leader>aa`  | diff 受け入れ            |
| `<Leader>ad`  | diff 拒否                |

### Neovim - メモ機能 (memolist.vim)

| キー         | 動作         |
| ------------ | ------------ |
| `<Leader>mn` | 新規メモ作成 |
| `<Leader>ml` | メモ一覧表示 |
| `<Leader>mg` | メモ検索     |

## 🌐 WSL2特化機能

- **Systemd対応**: より良いサービス管理
- **WindowsパスFromのワーディング**: Windows PATH汚染防止 (`appendWindowsPath=false`)
- **ディスプレイ設定**: 自動X11フォワーディング・WSL2ネイティブGUI対応
- **日本語ロケール**: 完全UTF-8日本語対応 (`ja_JP.UTF-8`)
- **Interop修正**: 自動WSL interop修復機能

## 🤖 AI機能の使い方

### Claude Code (claudecode.nvim)

Neovim内からClaude Codeを操作できます。

#### 基本操作

- `<Leader>ac`: Claude Codeウィンドウをトグル
- `<Leader>af`: Claude Codeにフォーカス
- `<Leader>ar`: 前回のセッションを再開
- `<Leader>aC`: セッションを継続
- `<Leader>am`: 使用するモデルを選択

#### バッファ・選択範囲の操作

- `<Leader>ab`: 現在のバッファをClaude Codeに追加
- `<Leader>as`: 選択範囲をClaude Codeに送信（ビジュアルモード）

#### diff操作

- `<Leader>aa`: Claude Codeの提案するdiffを受け入れ
- `<Leader>ad`: Claude Codeの提案するdiffを拒否

## 📝 メモ機能

memolist.vimによるテキストメモ管理機能を搭載しています。

### メモの保存場所

- **パス**: `~/Documents/memolist/`
- **形式**: Markdownファイル (`.md`)
- **ファイル名**: `YYYYMMDD_メモタイトル.md`

### 使い方

```vim
" 新規メモ作成
<Leader>mn または :MemoNew

" メモ一覧表示（Neo-treeで表示）
<Leader>ml または :MemoList

" メモを検索
<Leader>mg または :MemoGrep
```

## 🛠️ カスタマイズ

### 新しい言語の追加

1. `nvim/lua/lsp/servers.lua`にLSPサーバーを追加

   ```lua
   -- 例：Zig言語を追加
   if vim.fn.executable('zls') == 1 then
       vim.lsp.config.zls = {
           capabilities = capabilities,
       }
   end
   ```

2. `nvim/lua/plugins/formatter.lua`にフォーマッターを追加

   ```lua
   formatters_by_ft = {
       zig = { "zigfmt" },
   }
   ```

3. Masonまたはシステムパッケージマネージャーでツールをインストール

### Tmuxのカスタマイズ

- `tmux/tmux.conf`で設定変更
- プラグインリストに新しいプラグインを追加
- `Prefix + I`で新しいプラグインをインストール

### Bashカスタマイズ

- `bash/bashrc`にエイリアスや関数を追加
- `~/.bash_aliases`で追加エイリアスを作成
- 必要に応じて環境変数を変更

## 🔄 更新

設定を更新するには：

```bash
cd ~/dotfiles
git pull
./setup.sh
```

プラグインを更新するには：

- **Tmux**: `Prefix + U`
- **Neovim**: `:Lazy update`

## 🚨 トラブルシューティング

### セットアップスクリプト関連

#### 改行コードエラー（Windows環境）

```bash
# エラー: /usr/bin/env: 'bash\r': No such file or directory
# 解決方法
dos2unix setup.sh

# または一括変換
find scripts/ -name "*.sh" -type f -exec dos2unix {} \;
```

#### 実行権限エラー

```bash
# 実行権限を付与
chmod +x setup.sh
find scripts/ -name "*.sh" -type f -exec chmod +x {} \;
```

### WSL関連

#### apply-wsl-configコマンドが見つからない

```bash
# .bashrcを再読み込み
source ~/.bashrc

# または新しいターミナルを開く
```

#### WSL設定が適用されない

1. WSL設定を手動で適用：

   ```bash
   sudo cp ~/.wsl/wsl.conf /etc/wsl.conf
   ```

2. WSLを再起動：
   ```cmd
   wsl --shutdown
   ```

### Neovim関連

#### プラグインが読み込まれない

```vim
" Lazy.nvimの状態を確認
:Lazy

" プラグインを手動でインストール
:Lazy install

" プラグインを更新
:Lazy update
```

#### LSPが動作しない

```vim
" LSPの状態を確認
:LspInfo

" Masonでサーバーをインストール
:Mason
```

#### claudecode.nvimがエラーを出す

```bash
# 必要な依存関係を確認
# - folke/snacks.nvim

# Neovim内で再インストール
:Lazy install
```

## 📋 要件

- **OS**: WSL2, Ubuntu 20.04+, またはその他のDebian系Linux
- **Neovim**: 0.11.0以上（最新版推奨）
- **ツール**: git, curl, wget
- **Node.js**: 18.0.0以上（markdown-preview.nvim用）
- **オプション**:
  - pyenv (Python開発用)
  - nvm (Node.js開発用)
  - cargo (Rust開発用)
  - go (Go言語開発用)

## 📝 備考

- 全設定に日本語サポートが含まれています
- 開発ワークフローに最適化されています
- ローカル・リモート開発両方に対応
- VS Code ターミナル統合と互換性があります
- メモ機能でアイデアやTODOを素早く記録できます
- AI機能（Claude Code）で開発効率が大幅に向上します

## 🤝 貢献

フォークして独自のニーズに合わせてカスタマイズしてください。改善のためのプルリクエストも歓迎します！

## 📄 ライセンス

MIT License - 自由に使用・改変してください。
