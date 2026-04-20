# Windows 用 dotfiles セットアップスクリプト (PowerShell)
# 使用方法: .\setup.ps1 [-SkipNvim] [-SkipPlugins] [-SkipWSL] [-Only nvim,wsl] [-DryRun] [-Help]

param(
    [switch]$SkipNvim    = $false,
    [switch]$SkipPlugins = $false,
    [switch]$SkipWSL     = $false,
    [string[]]$Only      = @(),
    [switch]$DryRun      = $false,
    [switch]$Help        = $false
)

$DotfilesDir   = $PSScriptRoot
$NvimConfigDir = Join-Path $env:LOCALAPPDATA "nvim"
$NvimSourceDir = Join-Path $DotfilesDir "nvim"
$WslConfDir    = Join-Path $env:USERPROFILE ".wsl"
$WslConfTarget = Join-Path $WslConfDir "wsl.conf"
$WslConfSource = Join-Path $DotfilesDir "wsl\wsl.conf"

# ===== ログ関数 =====
function Write-InfoLog  { param([string]$m); Write-Host "[INFO] $m" -ForegroundColor Green  }
function Write-WarnLog  { param([string]$m); Write-Host "[WARN] $m" -ForegroundColor Yellow }
function Write-ErrorLog { param([string]$m); Write-Host "[ERROR] $m" -ForegroundColor Red   }
function Write-StepLog  { param([string]$m); Write-Host "[STEP] $m" -ForegroundColor Cyan   }

# ===== ヘルプ =====
function Show-Help {
    Write-Host @"
使用方法: .\setup.ps1 [オプション]

オプション:
  -SkipNvim      Neovim のセットアップをスキップ
  -SkipPlugins   Lazy.nvim プラグイン同期をスキップ
  -SkipWSL       WSL のセットアップをスキップ
  -Only <list>   指定コンポーネントのみ実行 (例: -Only nvim,wsl)
                 有効な値: nvim, wsl
  -DryRun        実行内容を表示するだけで変更しない
  -Help          このヘルプを表示

例:
  .\setup.ps1
  .\setup.ps1 -DryRun
  .\setup.ps1 -Only nvim
  .\setup.ps1 -Only nvim,wsl -DryRun
  .\setup.ps1 -SkipNvim
  .\setup.ps1 -SkipWSL -DryRun
"@
}

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

    if ($DryRun) {
        Write-InfoLog "[DRY-RUN] リンク作成 $Target -> $Source"
        return $true
    }

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
    if ($DryRun) {
        Write-InfoLog "[DRY-RUN] nvim --headless '+Lazy! sync' +qa"
        return
    }
    & nvim --headless "+Lazy! sync" +qa
    if ($LASTEXITCODE -ne 0) {
        Write-WarnLog "Lazy sync に失敗しました。起動後に :Lazy sync を実行してください"
    } else {
        Write-InfoLog "プラグインの同期が完了しました"
    }
}

# ===== WSL セットアップ =====
function Set-WSL {
    Write-StepLog "WSL をセットアップ中..."

    if (!(Get-Command wsl -ErrorAction SilentlyContinue)) {
        Write-WarnLog "wsl が見つかりません。WSL がインストールされていません"
        Write-InfoLog "インストール: 管理者 PowerShell で wsl --install を実行してください"
        return
    }

    if ($DryRun) {
        Write-InfoLog "[DRY-RUN] wsl --set-default-version 2"
    } else {
        & wsl --set-default-version 2
    }

    if (!(Test-Path $WslConfSource)) {
        Write-WarnLog "wsl.conf が見つかりません: $WslConfSource"
        return
    }

    if ($DryRun) {
        Write-InfoLog "[DRY-RUN] Copy-Item $WslConfSource -> $WslConfTarget"
    } else {
        if (!(Test-Path $WslConfDir)) {
            New-Item -ItemType Directory -Path $WslConfDir -Force | Out-Null
        }
        Copy-Item -Path $WslConfSource -Destination $WslConfTarget -Force
        Write-InfoLog "wsl.conf を $WslConfTarget にコピーしました"
    }

    Write-Host ""
    Write-Host "【WSL 設定の反映】" -ForegroundColor Cyan
    Write-Host "  WSL ディストリビューション内で以下を実行してください:"
    Write-Host "    sudo cp ~/.wsl/wsl.conf /etc/wsl.conf"
    Write-Host "  その後 WSL を再起動:"
    Write-Host "    wsl --shutdown"
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

# ===== コンポーネント実行判定 =====
function Should-Run {
    param([string]$Component)
    $components = ($Only -join ",") -split "," | ForEach-Object { $_.Trim().ToLower() }
    return $components -contains $Component.ToLower()
}

# ===== メイン =====
function Main {
    if ($Help) {
        Show-Help
        return
    }

    # -Only と -Skip* の併用チェック
    if ($Only.Count -gt 0 -and ($SkipNvim -or $SkipPlugins -or $SkipWSL)) {
        Write-ErrorLog "-Only と -Skip* は併用できません"
        exit 1
    }

    # 有効なコンポーネント検証
    $validComponents = @("nvim", "wsl")
    if ($Only.Count -gt 0) {
        $components = ($Only -join ",") -split "," | ForEach-Object { $_.Trim().ToLower() }
        foreach ($c in $components) {
            if ($c -notin $validComponents) {
                Write-ErrorLog "不明なコンポーネント: $c（有効: $($validComponents -join ', ')）"
                exit 1
            }
        }
    }

    # 実行するコンポーネントを決定
    $runNvim    = if ($Only.Count -gt 0) { Should-Run "nvim" } else { !$SkipNvim    }
    $runPlugins = if ($Only.Count -gt 0) { Should-Run "nvim" } else { !$SkipPlugins }
    $runWSL     = if ($Only.Count -gt 0) { Should-Run "wsl"  } else { !$SkipWSL     }

    if ($DryRun) {
        Write-WarnLog "DRY-RUN モード: 実際の変更は行いません"
    }

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

    if ($runNvim)    { Set-Neovim }
    if ($runPlugins) { Invoke-LazySync }
    if ($runWSL)     { Set-WSL }

    Show-Recommendations

    Write-InfoLog "セットアップが完了しました！"
    Read-Host "Enter キーを押して終了してください"
}

Main
