# WatanabeYuito's Dotfiles

🚀 **現代的な開発環境設定** - WSL2/Linux対応、日本語サポート付き

## ✨ 主な機能

- **🐚 Shell**: 共有履歴機能付きBash設定
- **🖥️ Terminal**: セッション永続化対応Tmux
- **✏️ Editor**: LSP・自動補完・AI支援付きNeovim
- **🤖 AI統合**: GitHub Copilot、CopilotChat、Avante.nvim（日本語プロンプト対応）
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
│       └── memolist.txt    # メモテンプレート
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

- **lualine.nvim**: モダンなステータスライン (Molokaiテーマ)
- **hlchunk.nvim**: インデントガイド・行番号ハイライト表示
- **neo-tree.nvim**: ツリー形式ファイルエクスプローラー
- **molokai**: カラースキーム
- **dressing.nvim**: UI選択・入力の改善
- **render-markdown.nvim**: Markdownコンテンツのリアルタイムレンダリング

#### エディタ機能

- **Comment.nvim**: 高速コメント切り替え
- **treesj**: 構造的な分割・結合機能
- **markdown-preview.nvim**: Markdownプレビュー機能
- **img-clip.nvim**: 画像のクリップボード貼り付けサポート
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

- **copilot.lua**: 次世代GitHub Copilot統合
  - リアルタイムコード補完
  - インサートモードでの高速提案
  - カスタマイズ可能なキーマップ
- **CopilotChat.nvim**: 対話型AI支援（日本語完全対応）
  - コード説明・レビュー
  - バグ修正・最適化提案
  - ドキュメント・テスト生成
  - カスタム日本語プロンプト
  - 選択範囲への直接適用
- **Avante.nvim**: 高度なAIコーディングアシスタント
  - Cursor風のUI/UX
  - インラインコード編集
  - 複数ファイル対応
  - AI駆動型リファクタリング
  - 依存プラグイン: dressing.nvim, plenary.nvim, nui.nvim, img-clip.nvim, render-markdown.nvim

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
```

#### バッチファイル版

```cmd
# リポジトリをクローン後、コマンドプロンプトを管理者として実行
cd %USERPROFILE%\dotfiles
setup.bat
```

**注意**: Windowsでシンボリックリンクを作成するには管理者権限が必要です。

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

### Neovim - 基本

| キー         | 動作                 |
| ------------ | -------------------- |
| `jj`         | インサートモード終了 |
| `<Esc><Esc>` | 検索ハイライト解除   |
| `Y`          | 行末までヤンク       |

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

### Neovim - Copilot (インサートモード)

| キー    | 動作                  |
| ------- | --------------------- |
| `C-J`   | 提案受け入れ          |
| `C-L`   | 単語単位で受け入れ    |
| `C-N`   | 次の提案              |
| `C-K`   | 前の提案              |
| `C-D`   | 提案拒否              |

### Neovim - Copilot管理

| キー          | 動作                  |
| ------------- | --------------------- |
| `<Leader>cpe` | Copilot有効化         |
| `<Leader>cpd` | Copilot無効化         |
| `<Leader>cps` | Copilotステータス確認 |

### Neovim - CopilotChat

| キー          | 動作                     |
| ------------- | ------------------------ |
| `<Leader>cc`  | チャット開始             |
| `<Leader>ccq` | クイックチャット         |
| `<Leader>ccv` | 選択範囲でチャット (V)   |
| `<Leader>ccx` | 選択範囲の修正 (V)       |
| `<Leader>cch` | チャット履歴             |
| `<Leader>ccr` | チャットリセット         |
| `<Leader>ce`  | コード説明（日本語）     |
| `<Leader>cr`  | コードレビュー（日本語） |
| `<Leader>cf`  | バグ修正                 |
| `<Leader>co`  | コード最適化             |
| `<Leader>cd`  | ドキュメント生成         |
| `<Leader>ct`  | テスト生成               |

### Neovim - Avante.nvim

| キー         | 動作           |
| ------------ | -------------- |
| `<Leader>aa` | Avante Ask     |
| `<Leader>ar` | Avante Refresh |
| `<Leader>ae` | Avante Edit    |
| `<Leader>at` | Avante Toggle  |
| `<Leader>af` | Avante Focus   |

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

### Copilot（copilot.lua）

#### 基本的な使い方

1. **Copilotの有効化**:

   ```
   <Leader>cpe または :Copilot enable
   ```

2. **Copilotの無効化**:

   ```
   <Leader>cpd または :Copilot disable
   ```

3. **ステータス確認**:
   ```
   <Leader>cps または :Copilot status
   ```

#### インサートモードでの補完

- `C-J`: 提案を受け入れる
- `C-L`: 単語単位で受け入れる
- `C-N`: 次の提案
- `C-K`: 前の提案
- `C-D`: 提案を拒否

### CopilotChat

#### 基本操作

- `<Leader>cc`: チャットウィンドウを開く
- `<Leader>ccq`: クイックチャット（入力プロンプト）
- `<Leader>ccv`: 選択範囲でチャット（ビジュアルモード）
- `<Leader>ccx`: 選択範囲の修正（プロンプト入力、ビジュアルモード）
- `<Leader>cch`: チャット履歴を表示
- `<Leader>ccr`: チャットをリセット

#### 専用プロンプト（日本語対応）

- `<Leader>ce`: コードの説明を日本語で要求
- `<Leader>cr`: コードレビューを日本語で要求
- `<Leader>cf`: バグ修正提案
- `<Leader>co`: コード最適化提案
- `<Leader>cd`: ドキュメント生成
- `<Leader>ct`: テストコード生成

### Avante.nvim

高度なAIコーディングアシスタント機能を提供します：

- `<Leader>aa`: AIに質問（ノーマルモード・ビジュアルモード）
- `<Leader>ar`: Avanteを更新
- `<Leader>ae`: Avanteエディット
- `<Leader>at`: Avanteトグル
- `<Leader>af`: Avanteにフォーカス

Cursor IDEのようなインライン編集と、複数ファイルにまたがるリファクタリングが可能です。

## 📝 メモ機能

memolist.vimによるテキストメモ管理機能を搭載しています。

### メモの保存場所

- **パス**: `~/Documents/memolist/`
- **形式**: テキストファイル (`.txt`)
- **ファイル名**: `YYYYMMDD_HH:MM-メモタイトル.txt`

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

#### Copilot認証エラー

```vim
" Copilotの設定状態を確認
:Copilot status

" 認証を再実行
:Copilot setup
```

#### Avante.nvimがエラーを出す

Avante.nvimは多くの依存関係があります：

```bash
# 必要な依存関係を確認
# - copilot.lua
# - dressing.nvim
# - plenary.nvim
# - nui.nvim
# - img-clip.nvim
# - render-markdown.nvim
# - nvim-cmp
# - nvim-web-devicons

# Neovim内で再インストール
:Lazy install
```

## 📋 要件

- **OS**: WSL2, Ubuntu 20.04+, またはその他のDebian系Linux
- **Neovim**: 0.10.0以上（最新版推奨）
- **ツール**: git, curl, wget
- **Node.js**: 18.0.0以上（Copilot.lua, Avante.nvim用）
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
- AI機能（Copilot, CopilotChat, Avante）で開発効率が大幅に向上します

## 🤝 貢献

フォークして独自のニーズに合わせてカスタマイズしてください。改善のためのプルリクエストも歓迎します！

## 📄 ライセンス

MIT License - 自由に使用・改変してください。
