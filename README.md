# WatanabeYuito's Dotfiles

🚀 **現代的な開発環境設定** - WSL2/Linux対応、日本語サポート付き

## ✨ 主な機能

- **🐚 Shell**: 共有履歴機能付きBash設定
- **🖥️ Terminal**: セッション永続化対応Tmux
- **✏️ Editor**: LSP・自動補完・AI支援付きNeovim
- **🤖 AI統合**: GitHub Copilot & CopilotChat（日本語プロンプト対応）
- **🏠 WSL2最適化**: Windows環境との完全統合
- **🌍 多言語対応**: Python, Rust, TypeScript, Go, Lua, PowerShell

## 📁 構成

```
dotfiles/
├── bash/
│   └── bashrc              # 強化されたBash設定
├── tmux/
│   ├── tmux.conf          # プラグイン対応Tmux設定
│   └── plugins/           # Tmuxプラグイン群
├── nvim/
│   ├── init.lua           # Neovim エントリーポイント
│   ├── lua/
│   │   ├── options.lua    # エディタオプション
│   │   ├── keymaps.lua    # キーマッピング
│   │   ├── plugins.lua    # lazy.nvimプラグイン管理
│   │   ├── lsp-config.lua # 言語サーバー設定
│   │   ├── cmp-config.lua # 自動補完設定
│   │   └── conform-config.lua # コードフォーマット設定
│   └── colors/molokai.vim # カラースキーム
├── wsl/
│   └── wsl.conf           # WSL設定
└── scripts/               # インストール・セットアップスクリプト
```

## 🎯 特徴的な設定

### Bash設定

- **共有履歴**: 全ターミナル間でコマンド履歴を共有
- **WSL2統合**: 自動interop修正・ディスプレイ設定
- **開発ツール統合**:
  - Python (pyenv)
  - Rust (cargo)
  - Node.js (nvm)
- **日本語環境**: UTF-8ロケール完全対応

### Tmux設定

- **プレフィックスキー**: `Ctrl+j` (デフォルトの`Ctrl+b`から変更)
- **Vimスタイルナビゲーション**: `hjkl`でペイン移動、`HJKL`でリサイズ
- **セッション永続化**: 自動保存・復元 (tmux-resurrect/continuum)
- **モダンUI**: カスタムステータスバー
- **マウス対応**: フル統合マウスサポート

### Neovim設定

- **プラグイン管理**: lazy.nvim による高速起動
- **LSP対応**: 多言語サーバー自動設定
- **AI統合**:
  - GitHub Copilot コード補完
  - CopilotChat 対話型AI支援（日本語対応）
- **自動フォーマット**: 保存時自動フォーマット (conform.nvim)
- **ファイル探索**: Neo-tree統合
- **シンタックスハイライト**: Treesitter対応

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
git clone <your-repository-url> ~/dotfiles

# セットアップスクリプトを実行
cd ~/dotfiles
chmod +x setup.sh

# 通常実行（sudoなしで実行可能）
./setup.sh

# bash設定を反映（自動実行されますが、手動でも可能）
source ~/.bashrc

# Neovimを起動してプラグインの自動インストールを確認
nvim
```

### WSL設定の適用

WSLの場合、追加セットアップが必要です：

```bash
# 方法1: エイリアスを使用（推奨）
apply-wsl-config

# 方法2: スクリプトを直接実行
sudo ~/.wsl/apply-wsl-config.sh

# 方法3: 手動でコピー
sudo cp ~/.wsl/wsl.conf /etc/wsl.conf
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
| `Prefix + S`    | セッション選択     |
| `Prefix + y`    | ペイン同期切り替え |

### Neovim

| キー        | 動作                 |
| ----------- | -------------------- |
| `jj`        | インサートモード終了 |
| `<Space>f`  | コードフォーマット   |
| `<Space>e`  | 診断表示             |
| `gd`        | 定義へジャンプ       |
| `gr`        | 参照表示             |
| `<Space>rn` | リネーム             |
| `<Space>ca` | コードアクション     |

### Copilot (インサートモード)

| キー     | 動作         |
| -------- | ------------ |
| `Ctrl+J` | 提案受け入れ |
| `Ctrl+L` | 単語受け入れ |
| `Ctrl+K` | 前の提案     |
| `Ctrl+N` | 次の提案     |
| `Ctrl+D` | 提案拒否     |

### Copilot管理

| キー          | 動作                  |
| ------------- | --------------------- |
| `<Leader>cpe` | Copilot有効化         |
| `<Leader>cpd` | Copilot無効化         |
| `<Leader>cps` | Copilotステータス確認 |

### CopilotChat

| キー         | 動作                     |
| ------------ | ------------------------ |
| `<Leader>cc` | チャット開始             |
| `<Leader>ce` | コード説明（日本語）     |
| `<Leader>cr` | コードレビュー（日本語） |
| `<Leader>cf` | バグ修正                 |
| `<Leader>co` | コード最適化             |
| `<Leader>cd` | ドキュメント生成         |
| `<Leader>ct` | テスト生成               |

## 🌐 WSL2特化機能

- **Systemd対応**: より良いサービス管理
- **WindowsパスFromのワーディング**: Windows PATH汚染防止
- **ディスプレイ設定**: 自動X11フォワーディング
- **日本語ロケール**: 完全UTF-8日本語対応
- **Interop修正**: 自動WSL interop修復機能

## 🤖 Copilot使用方法

### 基本的な使い方

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

### インサートモードでの補完

- `Ctrl+J`: 提案を受け入れる
- `Ctrl+L`: 単語のみ受け入れる
- `Ctrl+K`: 前の提案
- `Ctrl+N`: 次の提案
- `Ctrl+D`: 提案を拒否

### CopilotChatの使用

- `<Leader>cc`: チャットウィンドウを開く
- `<Leader>ccq`: クイックチャット（選択範囲に対して）
- `<Leader>ccv`: 選択範囲でチャット（ビジュアルモード）
- `<Leader>cch`: チャット履歴を表示
- `<Leader>ccr`: チャットをリセット

### 専用プロンプト（日本語対応）

- `<Leader>ce`: コードの説明を日本語で要求
- `<Leader>cr`: コードレビューを日本語で要求
- `<Leader>cf`: バグ修正提案
- `<Leader>co`: コード最適化提案
- `<Leader>cd`: ドキュメント生成
- `<Leader>ct`: テストコード生成

## 🛠️ カスタマイズ

### 新しい言語の追加

1. `nvim/lua/lsp-config.lua`にLSPサーバーを追加
2. `nvim/lua/conform-config.lua`にフォーマッターを追加
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
cd dotfiles
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

## 📋 要件

- **OS**: WSL2, Ubuntu, またはその他のDebian系Linux
- **ツール**: git, curl, wget
- **オプション**: pyenv, nvm, rust, go（言語サポート用）

## 📝 備考

- 全設定に日本語サポートが含まれています
- 開発ワークフローに最適化されています
- ローカル・リモート開発両方に対応
- VS Code ターミナル統合と互換性があります

## 🤝 貢献

フォークして独自のニーズに合わせてカスタマイズしてください。改善のためのプルリクエストも歓迎します！

## 📄 ライセンス

MIT License - 自由に使用・改変してください。
