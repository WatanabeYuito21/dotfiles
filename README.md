### tmuxプラグインが動作しない（Linux/macOSのみ）

1. TPMがインストールされているか確認:

   ```bash
   ls ~/.tmux/plugins/tpm
   ```

2. tmux設定を再読み込み:
   ```bash
   tmux source-file ~/.config/tmux/### プラグインの追加
   ```

`lua/plugins.lua`の適切なカテゴリに新しいプラグインを追加:

```lua
-- 例: 新しいプラグインの追加
{
    'author/plugin-name',
    config = function()
        -- プラグイン設定
    end,
},
```

### tmux プラグインの管理

tmux プラグインは [TPM](https://github.com/tmux-plugins/tpm) で管理されます:

1. `tmux.conf` に新しいプラグインを追加:

   ```bash
   set -g @plugin 'plugin-author/plugin-name'
   ```

2. tmux内で `Prefix + I` を押してインストール

3. `Prefix + U` で更新、`Prefix + alt + u` でアンインストール# Neovim & tmux Dotfiles

個人用のNeovim・tmux設定ファイルです。Lua設定でモダンなNeovim環境と効率的なtmux環境を構築します。

## 機能

### Neovim設定

#### プラグイン構成

- **プラグインマネージャー**: [lazy.nvim](https://github.com/folke/lazy.nvim)
- **LSP**: nvim-lspconfig + Mason
- **補完**: nvim-cmp + LuaSnip
- **フォーマッター**: conform.nvim
- **ファイラー**: neo-tree.nvim
- **ステータスライン**: lualine.nvim
- **その他**: Comment.nvim, treesj, hlchunk.nvim

#### LSP対応言語

- Lua (lua-language-server)
- Python (pyright)
- TypeScript/JavaScript (typescript-language-server)
- Rust (rust-analyzer)
- Go (gopls)
- PowerShell (PowerShell Editor Services)
- Markdown (marksman)

#### 主要キーマップ

- `jj` → ESC (インサートモード・ターミナルモード)
- `<ESC><ESC>` → ハイライト解除
- `<Space>f` → フォーマット
- `<Space>rn` → リネーム
- `<Space>ca` → コードアクション
- `gd` → 定義ジャンプ
- `gr` → 参照検索
- `K` → ホバー情報

### tmux設定

#### 主要機能

- **Prefix キー**: `Ctrl-j` (デフォルトの`Ctrl-b`から変更)
- **vim風キーバインド**: hjklでペイン移動、HJKLでリサイズ
- **マウスサポート**: 有効
- **プラグインマネージャー**: [TPM](https://github.com/tmux-plugins/tpm)
- **セッション復元**: tmux-resurrect

#### キーバインド

- `Prefix + h/j/k/l` → ペイン移動
- `Prefix + H/J/K/L` → ペインリサイズ
- `Prefix + v` → 選択開始（vimコピーモード）
- `Prefix + y` → コピー
- `Prefix + I` → プラグインインストール

## インストール

### Linux/macOS環境

1. このリポジトリをクローン:

   ```bash
   git clone <your-repository-url> ~/dotfiles
   ```

2. セットアップスクリプトを実行:

   ```bash
   cd ~/dotfiles
   chmod +x setup.sh
   ./setup.sh
   ```

3. Neovimを起動してプラグインの自動インストールを確認:
   ```bash
   nvim
   ```

### Windows環境

#### PowerShell版（推奨）

1. このリポジトリをクローン:

   ```powershell
   git clone <your-repository-url> $env:USERPROFILE\dotfiles
   ```

2. PowerShellセットアップスクリプトを実行:
   ```powershell
   cd $env:USERPROFILE\dotfiles
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser  # 初回のみ
   .\setup.ps1
   ```

#### バッチファイル版

1. リポジトリをクローン後、コマンドプロンプトを**管理者として実行**
2. セットアップスクリプトを実行:
   ```cmd
   cd %USERPROFILE%\dotfiles
   setup.bat
   ```

**注意**: Windowsでシンボリックリンクを作成するには管理者権限が必要です。権限がない場合はジャンクションまたはコピーが使用されます。

### 共通の後処理

LSPサーバーをインストール（オプション）:

```vim
:Mason
```

### 必要な依存関係

### 必要な依存関係

#### 必須

- **Neovim** (>= 0.8.0)
- **Git**

#### Linux/macOS追加要件

- **tmux** (設定を使用する場合)

#### Windows推奨

- **Windows Terminal** (より良いターミナル体験)
- **PowerShell 7+** (PowerShellスクリプト使用時)
- **Nerd Font** (アイコン表示用、例: JetBrains Mono Nerd Font)

#### オプション（全プラットフォーム）

- **Python3** (Neovim provider用)
- **Node.js** (Markdown preview等)
- **各種言語ツール**:
  - Python: `pip install black isort`
  - JavaScript/TypeScript: `npm install -g prettier`
  - Rust: `rustup component add rustfmt`
  - Go: `go install -a std`
  - Lua: `stylua` (Windows: `scoop install stylua`)

## 設定ファイル構成

```
dotfiles/
├── nvim/                 # Neovim設定
│   ├── init.lua         # メイン設定ファイル
│   └── lua/
│       ├── options.lua       # 基本オプション
│       ├── keymaps.lua       # キーマップ
│       ├── plugins.lua       # プラグイン定義
│       ├── lsp-config.lua    # LSP設定
│       ├── cmp-config.lua    # 補完設定
│       └── conform-config.lua # フォーマッター設定
├── tmux/                # tmux設定（Linux/macOSのみ）
│   ├── tmux.conf        # tmux設定ファイル
│   └── plugins/         # TPMプラグイン（自動生成）
├── setup.sh             # Linux/macOS用セットアップスクリプト
├── setup.bat            # Windows用セットアップスクリプト（cmd）
├── setup.ps1            # Windows用セットアップスクリプト（PowerShell）
└── README.md            # このファイル
```

## カスタマイズ

### 新しいLSPサーバーの追加

`lua/lsp-config.lua`に以下のような設定を追加:

```lua
-- 新しい言語サーバーの例
if vim.fn.executable('language-server-binary') == 1 then
    lspconfig.server_name.setup({
        capabilities = capabilities,
        -- 言語固有の設定
    })
end
```

### tmux設定の追加

tmux設定を管理対象に追加する場合:

```bash
# 既存のtmux設定をdotfilesに移動
mv ~/.config/tmux ~/dotfiles/

# または新規作成
mkdir -p ~/dotfiles/tmux
cp /path/to/your/tmux.conf ~/dotfiles/tmux/

# セットアップスクリプトを再実行
./setup.sh
```

## 設定の同期

### 設定を更新した場合

```bash
# Linux/macOS
cd ~/dotfiles
git add .
git commit -m "Update config"
git push
```

```powershell
# Windows PowerShell
cd $env:USERPROFILE\dotfiles
git add .
git commit -m "Update config"
git push
```

### 他の端末で設定を同期

```bash
# Linux/macOS
cd ~/dotfiles
git pull
```

```powershell
# Windows
cd $env:USERPROFILE\dotfiles
git pull
```

## トラブルシューティング

### プラグインが読み込まれない

```vim
:Lazy sync
```

### LSPが動作しない

1. LSPサーバーがインストールされているか確認:

   ```vim
   :Mason
   ```

2. LSPの状態を確認:
   ```vim
   :LspInfo
   ```

### Windows固有のトラブルシューティング

#### シンボリックリンクが作成できない

1. **管理者権限で実行**:

   ```cmd
   # コマンドプロンプトを「管理者として実行」
   setup.bat
   ```

2. **PowerShellの実行ポリシー**:

   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

3. **代替方法（手動コピー）**:
   ```cmd
   xcopy "%USERPROFILE%\dotfiles\nvim" "%LOCALAPPDATA%\nvim" /E /I /Y
   ```

#### パスの問題

Windowsでは設定ファイルの場所が異なります：

- Neovim設定: `%LOCALAPPDATA%\nvim\` (`C:\Users\username\AppData\Local\nvim\`)
- Linux/macOS: `~/.config/nvim/`

### フォーマッターが動作しない

フォーマッターがインストールされているか確認:

```bash
# 例: Python
pip install black isort

# 例: JavaScript
npm install -g prettier
```

## 更新履歴

- 初期バージョン: 基本的なLSP + 補完 + フォーマッター構成
- lazy.nvimベースのプラグイン管理
- モジュール化された設定構造
- tmux設定の追加とTPM連携

## ライセンス

個人用設定ファイルのため、自由にご利用ください。
