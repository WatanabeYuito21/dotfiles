# Neovim, tmux, bash & WSL Dotfiles

個人用のNeovim・tmux・bash・WSL設定ファイルです。Lua設定でモダンなNeovim環境と効率的なtmux環境、カスタマイズされたbash環境、最適化されたWSL環境を構築します。

## 🚀 機能

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

### bash設定

#### 主要機能

- **pyenv設定**: Python バージョン管理の自動初期化
- **Cargo設定**: Rust 環境の自動読み込み
- **WSL2サポート**: Windows Subsystem for Linux 2 対応
- **履歴共有**: 複数のbashセッション間でリアルタイム履歴共有
- **カラープロンプト**: 見やすいカラー表示
- **基本エイリアス**: 便利なコマンドエイリアス

#### 主要なエイリアス

- `ll` → `ls -alF` (詳細リスト表示)
- `la` → `ls -A` (隠しファイル含む表示)
- `l` → `ls -CF` (簡潔な表示)
- カラー対応: `grep`, `fgrep`, `egrep`

#### 特殊機能

- **WSL2 Interop修正**: `fix_wsl2_interop()` 関数でプロセス間通信を修正
- **履歴共有**: `share_history()` 関数で複数セッション間の履歴同期

### WSL設定 🆕

#### 主要機能

- **systemd有効化**: systemdによるサービス管理
- **ネットワーク設定**: Windowsとの連携最適化
- **Interop設定**: Windows実行ファイルへのアクセス
- **自動マウント**: Windowsドライブの自動マウント

#### 設定内容

- systemdサポート
- デフォルトユーザー設定
- ホスト名生成の有効化
- DNS設定の自動生成
- Windows PATH の自動追加

## 📦 インストール

### Linux/macOS/WSL環境

```bash
# このリポジトリをクローン
git clone <your-repository-url> ~/dotfiles

# セットアップスクリプトを実行
cd ~/dotfiles
chmod +x setup.sh

# 通常実行（WSL設定以外）
./setup.sh

# WSL環境でWSL設定も含める場合（sudo権限必要）
sudo ./setup.sh

# bash設定を反映（自動で実行されますが、手動でも可能）
source ~/.bashrc

# Neovimを起動してプラグインの自動インストールを確認
nvim
```

### Windows環境

#### PowerShell版（推奨）

```powershell
# このリポジトリをクローン
git clone <your-repository-url> $env:USERPROFILE\dotfiles

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

### WSL設定の反映

WSL設定を変更した後は、WSLを再起動する必要があります：

**PowerShell/コマンドプロンプトで実行：**
```cmd
wsl --shutdown
```

その後、WSLを再起動すれば新しい設定が適用されます。

### 共通の後処理

LSPサーバーをインストール（オプション）:

```vim
:Mason
```

## 📂 設定ファイル構成

```
dotfiles/
├── nvim/                    # Neovim設定
│   ├── init.lua            # メイン設定ファイル
│   └── lua/
│       ├── options.lua     # 基本オプション
│       ├── keymaps.lua     # キーマップ
│       ├── plugins.lua     # プラグイン定義
│       ├── lsp-config.lua  # LSP設定
│       ├── cmp-config.lua  # 補完設定
│       └── conform-config.lua # フォーマッター設定
├── tmux/                   # tmux設定（Linux/macOSのみ）
│   ├── tmux.conf          # tmux設定ファイル
│   └── plugins/           # TPMプラグイン（自動生成）
├── bash/                   # bash設定
│   └── bashrc             # bash設定ファイル
├── wsl/                    # WSL設定 🆕
│   └── wsl.conf           # WSL設定ファイル
├── setup.sh               # Linux/macOS/WSL用セットアップスクリプト
├── setup.bat              # Windows用セットアップスクリプト（cmd）
├── setup.ps1              # Windows用セットアップスクリプト（PowerShell）
└── README.md             # このファイル
```

## ⚙️ 必要な依存関係

### 必須

- **Git**
- **bash** (Linux/macOS/WSL)

### Neovim関連

- **Neovim** (>= 0.8.0)
- **Python3** (Neovim provider用)
- **Node.js** (Markdown preview等)

### tmux関連（Linux/macOSのみ）

- **tmux**

### bash関連（推奨）

- **pyenv** (Python バージョン管理)
- **Cargo/Rust** (Rust 開発環境)

### WSL関連

- **Windows Subsystem for Linux 2**
- **sudo権限** (WSL設定ファイルの配置用)

### Windows推奨

- **Windows Terminal** (より良いターミナル体験)
- **PowerShell 7+** (PowerShellスクリプト使用時)
- **Nerd Font** (アイコン表示用、例: JetBrains Mono Nerd Font)

### 各種言語ツール（オプション）

- **Python**: `pip install black isort`
- **JavaScript/TypeScript**: `npm install -g prettier`
- **Rust**: `rustup component add rustfmt`
- **Go**: `go install -a std`
- **Lua**: `stylua` (Windows: `scoop install stylua`)

## 🔧 カスタマイズ

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

### Neovimプラグインの追加

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

### tmuxプラグインの管理

tmux プラグインは [TPM](https://github.com/tmux-plugins/tpm) で管理されます:

1. `tmux.conf` に新しいプラグインを追加:

   ```bash
   set -g @plugin 'plugin-author/plugin-name'
   ```

2. tmux内で `Prefix + I` を押してインストール

3. `Prefix + U` で更新、`Prefix + alt + u` でアンインストール

### bash設定の追加

#### カスタムエイリアス

`~/.bash_aliases`ファイルを作成して、個人的なエイリアスを追加:

```bash
# カスタムエイリアスの例
alias ..='cd ..'
alias ...='cd ../..'
alias v='nvim'
alias g='git'
```

#### 環境固有の設定

環境固有の設定は`~/.bashrc.local`に追加することをお勧めします（このファイルはgitignoreされます）。

### WSL設定のカスタマイズ 🆕

`wsl/wsl.conf`ファイルを編集してWSL動作をカスタマイズ:

```ini
[boot]
systemd=true
command="service cron start"  # 起動時コマンド

[user]
default=yourusername

[network]
generateHosts=true
generateResolvConf=true
hostname=custom-hostname

[interop]
enabled=true
appendWindowsPath=true

[automount]
enabled=true
mountFsTab=false
root=/mnt/
options="metadata,umask=22,fmask=11"
```

#### 主要設定項目

- **boot**: systemd有効化、起動時コマンド
- **user**: デフォルトユーザー設定
- **network**: DNS、ホスト名設定
- **interop**: Windows実行ファイルアクセス
- **automount**: Windowsドライブマウント設定

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

## 🔄 設定の同期

### 設定を更新した場合

```bash
# Linux/macOS/WSL
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
# Linux/macOS/WSL
cd ~/dotfiles
git pull

# 設定を再適用（必要に応じて）
./setup.sh  # または sudo ./setup.sh (WSL設定含む)
```

```powershell
# Windows
cd $env:USERPROFILE\dotfiles
git pull
```

## 🛠️ トラブルシューティング

### Neovim関連

#### プラグインが読み込まれない

```vim
:Lazy sync
```

#### LSPが動作しない

1. LSPサーバーがインストールされているか確認:

   ```vim
   :Mason
   ```

2. LSPの状態を確認:
   ```vim
   :LspInfo
   ```

### tmux関連

#### プラグインが動作しない（Linux/macOSのみ）

1. TPMがインストールされているか確認:

   ```bash
   ls ~/.tmux/plugins/tpm
   ```

2. tmux設定を再読み込み:
   ```bash
   tmux source-file ~/.config/tmux/tmux.conf
   ```

### bash関連

#### bash設定が反映されない

```bash
# bash設定を手動で再読み込み
source ~/.bashrc

# または新しいターミナルを開く
```

#### pyenvが動作しない

```bash
# pyenvのパスを確認
echo $PYENV_ROOT
echo $PATH

# pyenvを再インストール
curl https://pyenv.run | bash
```

#### WSL2でInterop機能が動作しない

```bash
# WSL2 Interopを手動で修正
fix_wsl2_interop
```

### WSL関連 🆕

#### WSL設定が適用されない

1. **sudo権限でセットアップを実行**:

   ```bash
   sudo ./setup.sh
   ```

2. **WSL設定ファイルを手動で配置**:

   ```bash
   sudo cp ~/dotfiles/wsl/wsl.conf /etc/wsl.conf
   ```

3. **WSLを再起動**:

   ```cmd
   # PowerShell/コマンドプロンプトで実行
   wsl --shutdown
   ```

#### systemdが動作しない

1. WSL設定を確認:

   ```bash
   cat /etc/wsl.conf
   ```

2. systemdの状態を確認:

   ```bash
   systemctl status
   ```

#### setup.shでsudo権限エラーが発生

```bash
# 権限を確認
sudo -l

# sudoグループに属しているか確認
groups $USER

# 手動でWSL設定をコピー
sudo cp ~/dotfiles/wsl/wsl.conf /etc/wsl.conf
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

## 📋 推奨インストール手順

### pyenvのインストール（Python バージョン管理）

```bash
# pyenvをインストール
curl https://pyenv.run | bash

# bashrcが既に設定済みなので、新しいターミナルを開くか：
source ~/.bashrc

# Pythonをインストール
pyenv install 3.11.0
pyenv global 3.11.0
```

### Rustのインストール（Rust 開発環境）

```bash
# Rustをインストール
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# bashrcが既に設定済みなので、新しいターミナルを開くか：
source ~/.bashrc
```

### WSL設定の初期セットアップ 🆕

```bash
# WSL設定ディレクトリを作成
mkdir -p ~/dotfiles/wsl

# 基本的なWSL設定ファイルを作成
cat << 'EOF' > ~/dotfiles/wsl/wsl.conf
[boot]
systemd=true

[user]
default=watanabeyuito

[network]
generateHosts=true
generateResolvConf=true

[interop]
enabled=true
appendWindowsPath=true

[automount]
enabled=true
root=/mnt/
options="metadata,umask=22,fmask=11"
EOF

# セットアップスクリプトをsudo権限で実行
sudo ./setup.sh
```

## 📈 更新履歴

- **v1.0**: 基本的なNeovim LSP + 補完 + フォーマッター構成
- **v1.1**: lazy.nvimベースのプラグイン管理
- **v1.2**: モジュール化された設定構造
- **v1.3**: tmux設定の追加とTPM連携
- **v1.4**: bash設定の追加（pyenv, Cargo, WSL2サポート, 履歴共有）
- **v1.5**: WSL設定の追加（systemd有効化、ネットワーク設定、Interop設定） 🆕

## 📄 ライセンス

個人用設定ファイルのため、自由にご利用ください。
