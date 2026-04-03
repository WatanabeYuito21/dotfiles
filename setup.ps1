# Windows 用 dotfiles セットアップスクリプト (PowerShell)
# 使用方法: .\setup.ps1 [-SkipNvim] [-SkipPlugins]

param(
    [switch]$SkipNvim    = $false,
    [switch]$SkipPlugins = $false
)

$DotfilesDir   = $PSScriptRoot
$NvimConfigDir = Join-Path $env:LOCALAPPDATA "nvim"
$NvimSourceDir = Join-Path $DotfilesDir "nvim"

# ===== ログ関数 =====
function Write-InfoLog  { param([string]$m); Write-Host "[INFO] $m" -ForegroundColor Green  }
function Write-WarnLog  { param([string]$m); Write-Host "[WARN] $m" -ForegroundColor Yellow }
function Write-ErrorLog { param([string]$m); Write-Host "[ERROR] $m" -ForegroundColor Red   }
function Write-StepLog  { param([string]$m); Write-Host "[STEP] $m" -ForegroundColor Cyan   }

# ===== 管理者権限チェック =====
function Test-Administrator {
    $current = [Security.Principal.WindowsIdentity]::GetCurrent()
    ([Security.Principal.WindowsPrincipal]$current).IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator
    )
}

# ===== 依存関係チェック =====
function Test-Dependencies {
    Write-StepLog "依存関係をチェック中..."

    foreach ($cmd in @("nvim", "git")) {
        if (!(Get-Command $cmd -ErrorAction SilentlyContinue)) {
            Write-ErrorLog "$cmd がインストールされていません（必須）"
            return $false
        }
    }

    foreach ($cmd in @("python", "node", "uv")) {
        if (!(Get-Command $cmd -ErrorAction SilentlyContinue)) {
            Write-WarnLog "$cmd が見つかりません（オプション）"
        }
    }

    Write-InfoLog "依存関係チェック完了"
    return $true
}

# ===== シンボリックリンク / ジャンクション 作成 =====
function New-DirLink {
    param([string]$Source, [string]$Target)

    if (Test-Path $Target) {
        $item = Get-Item $Target -Force
        if ($item.LinkType -in @("Junction", "SymbolicLink")) {
            Remove-Item $Target -Force
        } else {
            $backup = "$Target.bak.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
            Write-WarnLog "既存の設定を $backup にバックアップします"
            Move-Item $Target $backup
        }
    }

    $parent = Split-Path $Target -Parent
    if (!(Test-Path $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }

    try {
        if (Test-Administrator) {
            New-Item -ItemType SymbolicLink -Path $Target -Target $Source | Out-Null
        } else {
            New-Item -ItemType Junction -Path $Target -Target $Source | Out-Null
        }
        Write-InfoLog "$(Split-Path $Target -Leaf): リンク作成 $Target -> $Source"
        return $true
    } catch {
        Write-ErrorLog "リンクの作成に失敗しました: $_"
        Write-InfoLog "代替: xcopy `"$Source`" `"$Target`" /E /I /Y"
        return $false
    }
}

# ===== Neovim 設定 =====
function Set-Neovim {
    Write-StepLog "Neovim 設定をセットアップ中..."
    if (!(Test-Path $NvimSourceDir)) {
        Write-WarnLog "Neovim 設定が見つかりません: $NvimSourceDir"
        return
    }
    New-DirLink -Source $NvimSourceDir -Target $NvimConfigDir | Out-Null
}

# ===== Lazy.nvim プラグイン同期 =====
function Invoke-LazySync {
    Write-StepLog "Lazy.nvim プラグインを同期中..."
    & nvim --headless "+Lazy! sync" +qa
    if ($LASTEXITCODE -ne 0) {
        Write-WarnLog "Lazy sync に失敗しました。起動後に :Lazy sync を実行してください"
    } else {
        Write-InfoLog "プラグインの同期が完了しました"
    }
}

# ===== 推奨事項 =====
function Show-Recommendations {
    Write-Host ""
    Write-Host "【Neovim】" -ForegroundColor Cyan
    Write-Host "  * LSP サーバーをインストール: :Mason"
    Write-Host "  * 推奨 LSP: lua-language-server, pyright, typescript-language-server,"
    Write-Host "              rust-analyzer, gopls, marksman"
    Write-Host ""
    Write-Host "【Windows 固有の推奨事項】" -ForegroundColor Cyan
    Write-Host "  * Windows Terminal の使用を推奨"
    Write-Host "  * PowerShell 7+ の使用を推奨"
    Write-Host "  * フォント: Nerd Fonts を推奨（例: JetBrains Mono Nerd Font）"
    Write-Host "  * パッケージマネージャー: Scoop または WinGet"

    if (!(Get-Command python -ErrorAction SilentlyContinue)) {
        Write-Host "  * Python: https://www.python.org/downloads/" -ForegroundColor Yellow
    }
    if (!(Get-Command node -ErrorAction SilentlyContinue)) {
        Write-Host "  * Node.js: https://nodejs.org/" -ForegroundColor Yellow
    }
    Write-Host ""
}

# ===== メイン =====
function Main {
    Write-InfoLog "dotfiles セットアップを開始します (DotfilesDir=$DotfilesDir)"

    if (!(Test-Path $DotfilesDir)) {
        Write-ErrorLog "dotfiles ディレクトリが見つかりません: $DotfilesDir"
        exit 1
    }

    if (!(Test-Dependencies)) {
        exit 1
    }

    if (!(Test-Administrator)) {
        Write-WarnLog "管理者権限なし — SymbolicLink の代わりに Junction を使用します"
    }

    if (!$SkipNvim) { Set-Neovim }
    if (!$SkipPlugins) { Invoke-LazySync }

    Show-Recommendations

    Write-InfoLog "セットアップが完了しました！"
    Read-Host "Enter キーを押して終了してください"
}

Main
