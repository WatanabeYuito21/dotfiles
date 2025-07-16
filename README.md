## 🚀 インストール

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

WSLの場合、初回セットアップ後にWSL設定を適用する必要があります：

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

その後、WSLを再起動すれば新しい設定が適用されます。

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

## 🔧 トラブルシューティング

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

#### スクリプトが見つからない

```bash
# scripts/ディレクトリの存在確認
ls -la scripts/

# シンボリックリンクの確認
ls -la setup.sh
```

### WSL関連

#### WSL設定が適用されない

1. **WSL設定を手動で適用**:

   ```bash
   # エイリアスを使用
   apply-wsl-config
   
   # または直接実行
   sudo ~/.wsl/apply-wsl-config.sh
   ```

2. **WSL設定ファイルを手動で配置**:

   ```bash
   sudo cp ~/.wsl/wsl.conf /etc/wsl.conf
   ```

3. **WSLを再起動**:

   ```cmd
   # PowerShell/コマンドプロンプトで実行
   wsl --shutdown
   ```

#### systemdが動作しない

1. WSL設定を確認

   ```bash
   cat /etc/wsl.conf
   ```

2. systemdの状況を確認

   ```bash
   systemctl status
   ```

#### apply-wsl-configコマンドが見つからない

```bash
# .bashrcを再読み込み
source ~/.bashrc

# または新しいターミナルを開く
```

#### WSL設定ファイルが準備されていない

```bash
# セットアップスクリプトを再実行
./setup.sh

# WSL設定ディレクトリの確認
ls -la ~/.wsl/
```

### bash関連

#### apply-wsl-configエイリアスが動作しない

```bash
# エイリアスの確認
alias | grep apply-wsl-config

# 手動でエイリアスを追加
echo 'alias apply-wsl-config="sudo ~/.wsl/apply-wsl-config.sh"' >> ~/.bashrc
source ~/.bashrc
```

#### WSL2でInterop機能が動作しない

```bash
# WSL2 Interopを手動で修正
fix_wsl2_interop
```

## 🎯 推奨インストール手順

### WSL設定の初期セットアップ

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

# セットアップスクリプトを実行
./setup.sh

# WSL設定を適用
apply-wsl-config
```

## 📚 開発者向け情報

### WSL設定の自動化について

v2.0以降、WSL設定はユーザー空間で管理され、以下の利点があります：

1. **セキュリティ**: メインスクリプトはsudo権限なしで実行可能
2. **柔軟性**: WSL設定の適用タイミングを選択可能
3. **デバッグ性**: 問題の特定が容易
4. **保守性**: 各設定が独立して管理される

### WSL設定の仕組み

1. セットアップ時に`~/.wsl/`ディレクトリが作成される
2. WSL設定ファイルがユーザー空間にコピーされる
3. 適用用スクリプト（`apply-wsl-config.sh`）が生成される
4. `.bashrc`に便利なエイリアスが追加される

### 新しいWSL設定の追加

```bash
# ~/.wsl/wsl.confを編集
nano ~/.wsl/wsl.conf

# 設定を適用
apply-wsl-config
```
