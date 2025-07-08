# Windows用 Neovim dotfiles セットアップスクリプト (PowerShell)
# 使用方法: .\setup.ps1

param(
    [switch]$Force = $false
)

# 色付きログ出力関数
function Write-InfoLog {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Green
}

function Write-WarnLog {
    param([string]$Message)
    Write-Host "[WARN] $Message" -ForegroundColor Yellow
}

function Write-ErrorLog {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

# 管理者権限チェック
function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# 依存関係チェック
function Test-Dependencies {
    Write-InfoLog "依存関係をチェック中..."

    # Neovim
    try {
        $nvimVersion = & nvim --version 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-InfoLog "Neovim が利用可能です"
        } else {
            throw "Neovim not found"
        }
    } catch {
        Write-ErrorLog "Neovim がインストールされていません"
        Write-InfoLog "以下からNeovimをインストールしてください:"
        Write-InfoLog "https://github.com/neovim/neovim/releases"
        return $false
    }

    # Git
    try {
        $gitVersion = & git --version 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-InfoLog "Git が利用可能です"
        } else {
            throw "Git not found"
        }
    } catch {
        Write-ErrorLog "Git がインストールされていません"
        Write-InfoLog "以下からGitをインストールしてください:"
        Write-InfoLog "https://git-scm.com/download/win"
        return $false
    }

    # Python (オプション)
    try {
        $pythonVersion = & python --version 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-InfoLog "Python が利用可能です"
        } else {
            throw "Python not found"
        }
    } catch {
        Write-WarnLog "Python がインストールされていません（一部機能が制限される可能性があります）"
        Write-InfoLog "推奨: https://www.python.org/downloads/"
    }

    # Node.js (オプション)
    try {
        $nodeVersion = & node --version 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-InfoLog "Node.js が利用可能です"
        } else {
            throw "Node.js not found"
        }
    } catch {
        Write-WarnLog "Node.js がインストールされていません（Markdown preview等が動作しない可能性があります）"
        Write-InfoLog "推奨: https://nodejs.org/"
    }

    Write-InfoLog "依存関係チェック完了"
    return $true
}

# Neovim設定のセットアップ
function Set-NeovimConfig {
    param(
        [string]$SourcePath,
        [string]$TargetPath
    )

    Write-InfoLog "Neovim設定をセットアップ中..."
    Write-InfoLog "ソースディレクトリ: $SourcePath"
    Write-InfoLog "ターゲットディレクトリ: $TargetPath"

    # 既存の設定を処理
    if (Test-Path $TargetPath) {
        $item = Get-Item $TargetPath

        if ($item.LinkType -eq "Junction" -or $item.LinkType -eq "SymbolicLink") {
            Write-InfoLog "既存のシンボリックリンクを削除します"
            Remove-Item $TargetPath -Force
        } else {
            $backupName = "$TargetPath.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
            Write-WarnLog "既存の設定を $backupName にバックアップします"
            Move-Item $TargetPath $backupName
        }
    }

    # 親ディレクトリを作成
    $parentDir = Split-Path $TargetPath -Parent
    if (!(Test-Path $parentDir)) {
        New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
    }

    # シンボリックリンクを作成
    try {
        if (Test-Administrator) {
            New-Item -ItemType SymbolicLink -Path $TargetPath -Target $SourcePath | Out-Null
            Write-InfoLog "シンボリックリンクを作成しました"
        } else {
            # 管理者権限がない場合はジャンクションを試行
            New-Item -ItemType Junction -Path $TargetPath -Target $SourcePath | Out-Null
            Write-InfoLog "ジャンクションを作成しました"
        }

        Get-ChildItem $TargetPath | Select-Object Name, LinkType
        return $true
    } catch {
        Write-ErrorLog "リンクの作成に失敗しました: $_"
        Write-InfoLog "代替方法として設定をコピーしますか? (Y/N)"
        $response = Read-Host

        if ($response -eq 'Y' -or $response -eq 'y') {
            Copy-Item $SourcePath $TargetPath -Recurse -Force
            Write-InfoLog "設定をコピーしました（シンボリックリンクではありません）"
            return $true
        }

        return $false
    }
}

# Lazy.nvimの初期化
function Initialize-LazyNvim {
    Write-InfoLog "Lazy.nvim プラグインマネージャーを初期化中..."

    try {
        & nvim --headless "+Lazy! sync" +qa
        if ($LASTEXITCODE -eq 0) {
            Write-InfoLog "プラグインのインストールが完了しました"
        } else {
            throw "Lazy sync failed"
        }
    } catch {
        Write-WarnLog "プラグインの自動インストールに失敗しました"
        Write-InfoLog "Neovim起動後に手動で :Lazy sync を実行してください"
    }
}

# 推奨事項の表示
function Show-Recommendations {
    Write-InfoLog "セットアップ後の推奨事項:"
    Write-Host ""
    Write-Host "【Neovim】" -ForegroundColor Cyan
    Write-Host "  • LSPサーバーをインストール: :Mason"
    Write-Host "  • 推奨LSPサーバー:"
    Write-Host "    - Lua: lua-language-server"
    Write-Host "    - Python: pyright"
    Write-Host "    - TypeScript/JavaScript: typescript-language-server"
    Write-Host "    - Rust: rust-analyzer"
    Write-Host "    - Go: gopls"
    Write-Host "    - PowerShell: PowerShell Editor Services"
    Write-Host "    - Markdown: marksman"
    Write-Host ""

    Write-Host "【フォーマッター】" -ForegroundColor Cyan
    Write-Host "  • Python: pip install black isort"
    Write-Host "  • JavaScript/TypeScript: npm install -g prettier"
    Write-Host "  • Lua: scoop install stylua (要Scoop)"
    Write-Host ""

    Write-Host "【Windows固有の推奨事項】" -ForegroundColor Cyan
    Write-Host "  • Windows Terminal の使用を推奨"
    Write-Host "  • PowerShell 7+ の使用を推奨"
    Write-Host "  • フォント: Nerd Fonts を推奨（例: JetBrains Mono Nerd Font）"
    Write-Host "  • パッケージマネージャー: Scoop または Chocolatey の使用を推奨"
    Write-Host ""
}

# メイン処理
function Main {
    Write-InfoLog "Windows用 Neovim dotfiles セットアップを開始します..."

    # 変数設定
    $dotfilesDir = "$env:USERPROFILE\dotfiles"
    $nvimConfigDir = "$env:LOCALAPPDATA\nvim"

    Write-InfoLog "現在のディレクトリ: $(Get-Location)"
    Write-InfoLog "DOTFILES_DIR: $dotfilesDir"
    Write-InfoLog "NVIM_CONFIG_DIR: $nvimConfigDir"

    # dotfilesディレクトリの確認
    if (!(Test-Path $dotfilesDir)) {
        Write-ErrorLog "dotfiles ディレクトリが見つかりません: $dotfilesDir"
        Read-Host "Enterキーを押して終了してください"
        exit 1
    }

    # nvim設定の確認
    $nvimSourceDir = Join-Path $dotfilesDir "nvim"
    if (!(Test-Path $nvimSourceDir)) {
        Write-ErrorLog "Neovim設定が見つかりません: $nvimSourceDir"
        Write-InfoLog "dotfilesディレクトリの内容:"
        Get-ChildItem $dotfilesDir | Format-Table Name, ItemType
        Read-Host "Enterキーを押して終了してください"
        exit 1
    }

    # 利用可能な設定を表示
    Write-InfoLog "利用可能な設定:"
    if (Test-Path $nvimSourceDir) {
        Write-Host "  ✓ Neovim設定" -ForegroundColor Green
    } else {
        Write-Host "  ✗ Neovim設定" -ForegroundColor Red
    }
    Write-Host ""

    # 依存関係チェック
    if (!(Test-Dependencies)) {
        Read-Host "依存関係のエラーが発生しました。Enterキーを押して終了してください"
        exit 1
    }

    # 管理者権限の確認
    if (!(Test-Administrator)) {
        Write-WarnLog "管理者権限で実行されていません"
        Write-InfoLog "シンボリックリンクの作成に失敗した場合、ジャンクションまたはコピーを試行します"
    }

    # Neovim設定のセットアップ
    if (!(Set-NeovimConfig -SourcePath $nvimSourceDir -TargetPath $nvimConfigDir)) {
        Write-ErrorLog "Neovim設定のセットアップに失敗しました"
        Read-Host "Enterキーを押して終了してください"
        exit 1
    }

    # Lazy.nvimの初期化
    Initialize-LazyNvim

    # 推奨事項の表示
    Show-Recommendations

    Write-InfoLog "セットアップが完了しました！"
    Write-InfoLog "Neovim を起動して設定を確認してください: nvim"

    Read-Host "Enterキーを押して終了してください"
}

# スクリプト実行
Main
