@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

REM スクリプトのディレクトリを dotfiles ルートとして使用
set "DOTFILES_DIR=%~dp0"
set "DOTFILES_DIR=%DOTFILES_DIR:~0,-1%"
set "NVIM_CONFIG_DIR=%LOCALAPPDATA%\nvim"

echo [INFO] dotfiles セットアップを開始します (DOTFILES_DIR=%DOTFILES_DIR%)

REM dotfiles ディレクトリの存在確認
if not exist "%DOTFILES_DIR%" (
    echo [ERROR] dotfiles ディレクトリが見つかりません: %DOTFILES_DIR%
    pause
    exit /b 1
)

REM nvim 設定の存在確認
if not exist "%DOTFILES_DIR%\nvim" (
    echo [ERROR] Neovim 設定が見つかりません: %DOTFILES_DIR%\nvim
    pause
    exit /b 1
)

REM ===== 依存関係チェック =====
echo [STEP] 依存関係をチェック中...

nvim --version >nul 2>&1
if !errorlevel! neq 0 (
    echo [ERROR] Neovim がインストールされていません
    echo [INFO]  インストール: https://github.com/neovim/neovim/releases
    pause
    exit /b 1
)

git --version >nul 2>&1
if !errorlevel! neq 0 (
    echo [ERROR] Git がインストールされていません
    echo [INFO]  インストール: https://git-scm.com/download/win
    pause
    exit /b 1
)

python --version >nul 2>&1
if !errorlevel! neq 0 (
    echo [WARN] Python が見つかりません（オプション）
)

node --version >nul 2>&1
if !errorlevel! neq 0 (
    echo [WARN] Node.js が見つかりません（オプション）
)

echo [INFO] 依存関係チェック完了

REM ===== Neovim 設定セットアップ =====
echo [STEP] Neovim 設定をセットアップ中...

if exist "%NVIM_CONFIG_DIR%" (
    REM junction/symlink は rmdir で削除できる（/S なし）
    rmdir "%NVIM_CONFIG_DIR%" >nul 2>&1
    if !errorlevel! neq 0 (
        REM 通常ディレクトリの場合はバックアップ
        set "BACKUP_NAME=%NVIM_CONFIG_DIR%.bak.%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%%time:~6,2%"
        set "BACKUP_NAME=!BACKUP_NAME: =0!"
        echo [WARN] 既存の設定を !BACKUP_NAME! にバックアップします
        move "%NVIM_CONFIG_DIR%" "!BACKUP_NAME!" >nul
    )
)

mklink /D "%NVIM_CONFIG_DIR%" "%DOTFILES_DIR%\nvim" >nul 2>&1
if !errorlevel! neq 0 (
    echo [ERROR] シンボリックリンクの作成に失敗しました
    echo [INFO]  管理者として実行するか、代替として以下を使用してください:
    echo         xcopy "%DOTFILES_DIR%\nvim" "%NVIM_CONFIG_DIR%" /E /I /Y
    pause
    exit /b 1
)
echo [INFO] nvim: リンク作成 %NVIM_CONFIG_DIR% -^> %DOTFILES_DIR%\nvim

REM ===== Lazy.nvim プラグイン同期 =====
echo [STEP] Lazy.nvim プラグインを同期中...
nvim --headless "+Lazy! sync" +qa
if !errorlevel! neq 0 (
    echo [WARN] Lazy sync に失敗しました。起動後に :Lazy sync を実行してください
) else (
    echo [INFO] プラグインの同期が完了しました
)

REM ===== 推奨事項 =====
echo.
echo 【Neovim】
echo   * LSP サーバーをインストール: :Mason
echo   * 推奨 LSP: lua-language-server, pyright, typescript-language-server,
echo               rust-analyzer, gopls, marksman
echo.
echo 【Windows 固有の推奨事項】
echo   * Windows Terminal の使用を推奨
echo   * PowerShell 7+ の使用を推奨
echo   * フォント: Nerd Fonts を推奨（例: JetBrains Mono Nerd Font）
echo   * パッケージマネージャー: Scoop または WinGet
echo.

echo [INFO] セットアップが完了しました！
pause
