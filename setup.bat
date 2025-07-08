@echo off
setlocal enabledelayedexpansion

REM Windows用 Neovim dotfiles セットアップスクリプト
REM 使用方法: setup.bat

echo [INFO] Windows用 Neovim dotfiles セットアップを開始します...

REM 変数設定
set "DOTFILES_DIR=%USERPROFILE%\dotfiles"
set "NVIM_CONFIG_DIR=%LOCALAPPDATA%\nvim"

echo [INFO] 現在のディレクトリ: %CD%
echo [INFO] DOTFILES_DIR: %DOTFILES_DIR%
echo [INFO] NVIM_CONFIG_DIR: %NVIM_CONFIG_DIR%

REM dotfilesディレクトリの存在確認
if not exist "%DOTFILES_DIR%" (
    echo [ERROR] dotfiles ディレクトリが見つかりません: %DOTFILES_DIR%
    pause
    exit /b 1
)

REM nvimディレクトリの存在確認
if not exist "%DOTFILES_DIR%\nvim" (
    echo [ERROR] Neovim設定が見つかりません: %DOTFILES_DIR%\nvim
    echo [INFO] dotfilesディレクトリの内容:
    dir "%DOTFILES_DIR%"
    pause
    exit /b 1
)

echo [INFO] 利用可能な設定:
if exist "%DOTFILES_DIR%\nvim" (
    echo   * Neovim設定
) else (
    echo   x Neovim設定
)
echo.

REM 依存関係のチェック
echo [INFO] 依存関係をチェック中...

REM Neovimの確認
nvim --version >nul 2>&1
if !errorlevel! neq 0 (
    echo [ERROR] Neovim がインストールされていません
    echo [INFO] 以下からNeovimをインストールしてください:
    echo         https://github.com/neovim/neovim/releases
    pause
    exit /b 1
)

REM Gitの確認
git --version >nul 2>&1
if !errorlevel! neq 0 (
    echo [ERROR] Git がインストールされていません
    echo [INFO] 以下からGitをインストールしてください:
    echo         https://git-scm.com/download/win
    pause
    exit /b 1
)

REM Python3の確認（オプション）
python --version >nul 2>&1
if !errorlevel! neq 0 (
    echo [WARN] Python がインストールされていません（一部機能が制限される可能性があります）
    echo [INFO] 推奨: https://www.python.org/downloads/
) else (
    echo [INFO] Python が利用可能です
)

REM Node.jsの確認（オプション）
node --version >nul 2>&1
if !errorlevel! neq 0 (
    echo [WARN] Node.js がインストールされていません（Markdown preview等が動作しない可能性があります）
    echo [INFO] 推奨: https://nodejs.org/
) else (
    echo [INFO] Node.js が利用可能です
)

echo [INFO] 依存関係チェック完了
echo.

REM Neovim設定のセットアップ
echo [INFO] Neovim設定をセットアップ中...
echo [INFO] ソースディレクトリ: %DOTFILES_DIR%\nvim
echo [INFO] ターゲットディレクトリ: %NVIM_CONFIG_DIR%

REM 既存の設定をバックアップ
if exist "%NVIM_CONFIG_DIR%" (
    if not exist "%NVIM_CONFIG_DIR%\*.lnk" (
        set "BACKUP_NAME=%NVIM_CONFIG_DIR%.backup.%date:/=-%_%time::=-%"
        set "BACKUP_NAME=!BACKUP_NAME: =!"
        set "BACKUP_NAME=!BACKUP_NAME:.=!"
        echo [WARN] 既存の設定を !BACKUP_NAME! にバックアップします
        move "%NVIM_CONFIG_DIR%" "!BACKUP_NAME!"
    ) else (
        echo [INFO] 既存のシンボリックリンクを削除します
        rmdir "%NVIM_CONFIG_DIR%" >nul 2>&1
    )
)

REM LocalAppDataディレクトリを作成
if not exist "%LOCALAPPDATA%" (
    mkdir "%LOCALAPPDATA%"
)

REM シンボリックリンクを作成（管理者権限が必要）
echo [INFO] シンボリックリンクを作成しています...
mklink /D "%NVIM_CONFIG_DIR%" "%DOTFILES_DIR%\nvim" >nul 2>&1
if !errorlevel! neq 0 (
    echo [ERROR] シンボリックリンクの作成に失敗しました
    echo [INFO] 管理者権限で実行してください（コマンドプロンプトを「管理者として実行」）
    echo [INFO] または、以下の代替方法を使用してください:
    echo.
    echo [INFO] === 代替方法（手動コピー）===
    echo xcopy "%DOTFILES_DIR%\nvim" "%NVIM_CONFIG_DIR%" /E /I /Y
    echo.
    pause
    exit /b 1
)

echo [INFO] Neovim設定のシンボリックリンクを作成しました
dir "%NVIM_CONFIG_DIR%"

REM Lazy.nvimプラグインマネージャーの初期化
echo.
echo [INFO] Lazy.nvim プラグインマネージャーを初期化中...

REM Neovimを起動してプラグインをインストール
nvim --headless "+Lazy! sync" +qa
if !errorlevel! neq 0 (
    echo [WARN] プラグインの自動インストールに失敗しました
    echo [INFO] Neovim起動後に手動で :Lazy sync を実行してください
) else (
    echo [INFO] プラグインのインストールが完了しました
)

REM 推奨事項の表示
echo.
echo [INFO] セットアップ後の推奨事項:
echo.
echo 【Neovim】
echo   • LSPサーバーをインストール: :Mason
echo   • 推奨LSPサーバー:
echo     - Lua: lua-language-server
echo     - Python: pyright
echo     - TypeScript/JavaScript: typescript-language-server
echo     - Rust: rust-analyzer
echo     - Go: gopls
echo     - PowerShell: PowerShell Editor Services
echo     - Markdown: marksman
echo.
echo 【フォーマッター】
echo   • Python: pip install black isort
echo   • JavaScript/TypeScript: npm install -g prettier
echo   • Lua: 管理者PowerShellで scoop install stylua
echo.
echo 【Windows固有の設定】
echo   • Windows Terminalの使用を推奨
echo   • PowerShell 7+ の使用を推奨
echo   • フォントはNerd Fontsを推奨（例: JetBrains Mono Nerd Font）
echo.

echo [INFO] セットアップが完了しました！
echo [INFO] Neovim を起動して設定を確認してください: nvim

pause
