@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

REM ===== 初期化 =====
set "DOTFILES_DIR=%~dp0"
set "DOTFILES_DIR=%DOTFILES_DIR:~0,-1%"
set "NVIM_CONFIG_DIR=%LOCALAPPDATA%\nvim"
set "WSL_CONF_DIR=%USERPROFILE%\.wsl"

REM フラグ初期化
set "SKIP_NVIM="
set "SKIP_PLUGINS="
set "SKIP_WSL="
set "DRY_RUN="
set "SHOW_HELP="
set "ONLY="

REM ===== 引数パース =====
:parse_args
if "%~1"=="" goto end_parse_args
if /i "%~1"=="--help"         ( set "SHOW_HELP=1" & shift & goto parse_args )
if /i "%~1"=="-h"             ( set "SHOW_HELP=1" & shift & goto parse_args )
if /i "%~1"=="--dry-run"      ( set "DRY_RUN=1"   & shift & goto parse_args )
if /i "%~1"=="--skip-nvim"    ( set "SKIP_NVIM=1"    & shift & goto parse_args )
if /i "%~1"=="--skip-plugins" ( set "SKIP_PLUGINS=1" & shift & goto parse_args )
if /i "%~1"=="--skip-wsl"     ( set "SKIP_WSL=1"     & shift & goto parse_args )
if /i "%~1"=="--only" (
    if "%~2"=="" ( echo [ERROR] --only にはコンポーネントが必要です & goto show_help )
    set "ONLY=%~2"
    shift & shift & goto parse_args
)
echo [ERROR] 不明なオプション: %~1
goto show_help
:end_parse_args

REM ===== ヘルプ =====
if defined SHOW_HELP goto show_help

REM ===== --only と --skip-* の併用チェック =====
if defined ONLY (
    if defined SKIP_NVIM    ( echo [ERROR] --only と --skip-* は併用できません & exit /b 1 )
    if defined SKIP_PLUGINS ( echo [ERROR] --only と --skip-* は併用できません & exit /b 1 )
    if defined SKIP_WSL     ( echo [ERROR] --only と --skip-* は併用できません & exit /b 1 )
)

REM ===== --only からスキップフラグを設定 =====
if defined ONLY (
    set "SKIP_NVIM=1"
    set "SKIP_PLUGINS=1"
    set "SKIP_WSL=1"

    echo !ONLY! | findstr /i /c:"nvim" >nul 2>&1
    if not errorlevel 1 ( set "SKIP_NVIM=" & set "SKIP_PLUGINS=" )

    echo !ONLY! | findstr /i /c:"wsl" >nul 2>&1
    if not errorlevel 1 set "SKIP_WSL="
)

REM ===== DRY-RUN メッセージ =====
if "%DRY_RUN%"=="1" echo [WARN] DRY-RUN モード: 実際の変更は行いません

echo [INFO] dotfiles セットアップを開始します (DOTFILES_DIR=%DOTFILES_DIR%)

REM ===== dotfiles ディレクトリの存在確認 =====
if not exist "%DOTFILES_DIR%" (
    echo [ERROR] dotfiles ディレクトリが見つかりません: %DOTFILES_DIR%
    pause & exit /b 1
)

REM ===== 依存関係チェック =====
echo [STEP] 依存関係をチェック中...

nvim --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Neovim がインストールされていません
    echo [INFO]  インストール: https://github.com/neovim/neovim/releases
    pause & exit /b 1
)

git --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Git がインストールされていません
    echo [INFO]  インストール: https://git-scm.com/download/win
    pause & exit /b 1
)

python --version >nul 2>&1
if errorlevel 1 echo [WARN] Python が見つかりません（オプション）

node --version >nul 2>&1
if errorlevel 1 echo [WARN] Node.js が見つかりません（オプション）

echo [INFO] 依存関係チェック完了

REM ===== コンポーネント実行 =====
if not defined SKIP_NVIM    call :setup_nvim
if not defined SKIP_PLUGINS call :lazy_sync
if not defined SKIP_WSL     call :setup_wsl

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
exit /b 0

REM ===== Neovim セットアップ =====
:setup_nvim
echo [STEP] Neovim 設定をセットアップ中...

if not exist "%DOTFILES_DIR%\nvim" (
    echo [WARN] Neovim 設定が見つかりません: %DOTFILES_DIR%\nvim
    exit /b 0
)

if exist "%NVIM_CONFIG_DIR%" (
    rmdir "%NVIM_CONFIG_DIR%" >nul 2>&1
    if errorlevel 1 (
        set "BACKUP_NAME=%NVIM_CONFIG_DIR%.bak.%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%%time:~6,2%"
        set "BACKUP_NAME=!BACKUP_NAME: =0!"
        echo [WARN] 既存の設定を !BACKUP_NAME! にバックアップします
        if "%DRY_RUN%"=="1" (
            echo [DRY-RUN] move "%NVIM_CONFIG_DIR%" "!BACKUP_NAME!"
        ) else (
            move "%NVIM_CONFIG_DIR%" "!BACKUP_NAME!" >nul
        )
    )
)

if "%DRY_RUN%"=="1" (
    echo [DRY-RUN] mklink /D "%NVIM_CONFIG_DIR%" "%DOTFILES_DIR%\nvim"
) else (
    mklink /D "%NVIM_CONFIG_DIR%" "%DOTFILES_DIR%\nvim" >nul 2>&1
    if errorlevel 1 (
        echo [ERROR] シンボリックリンクの作成に失敗しました
        echo [INFO]  管理者として実行するか、代替として以下を使用してください:
        echo         xcopy "%DOTFILES_DIR%\nvim" "%NVIM_CONFIG_DIR%" /E /I /Y
        exit /b 1
    )
    echo [INFO] nvim: リンク作成 %NVIM_CONFIG_DIR% -^> %DOTFILES_DIR%\nvim
)
exit /b 0

REM ===== Lazy.nvim プラグイン同期 =====
:lazy_sync
echo [STEP] Lazy.nvim プラグインを同期中...
if "%DRY_RUN%"=="1" (
    echo [DRY-RUN] nvim --headless "+Lazy! sync" +qa
) else (
    nvim --headless "+Lazy! sync" +qa
    if errorlevel 1 (
        echo [WARN] Lazy sync に失敗しました。起動後に :Lazy sync を実行してください
    ) else (
        echo [INFO] プラグインの同期が完了しました
    )
)
exit /b 0

REM ===== WSL セットアップ =====
:setup_wsl
echo [STEP] WSL をセットアップ中...

wsl --version >nul 2>&1
if errorlevel 1 (
    echo [WARN] WSL が見つかりません
    echo [INFO] インストール: 管理者 PowerShell で wsl --install を実行してください
    exit /b 0
)

if "%DRY_RUN%"=="1" (
    echo [DRY-RUN] wsl --set-default-version 2
) else (
    wsl --set-default-version 2
)

if not exist "%DOTFILES_DIR%\wsl\wsl.conf" (
    echo [WARN] wsl.conf が見つかりません: %DOTFILES_DIR%\wsl\wsl.conf
    exit /b 0
)

if "%DRY_RUN%"=="1" (
    echo [DRY-RUN] mkdir "%WSL_CONF_DIR%"
    echo [DRY-RUN] copy "%DOTFILES_DIR%\wsl\wsl.conf" "%WSL_CONF_DIR%\wsl.conf"
) else (
    if not exist "%WSL_CONF_DIR%" mkdir "%WSL_CONF_DIR%"
    copy /Y "%DOTFILES_DIR%\wsl\wsl.conf" "%WSL_CONF_DIR%\wsl.conf" >nul
    echo [INFO] wsl.conf を %WSL_CONF_DIR%\wsl.conf にコピーしました
)

echo.
echo 【WSL 設定の反映】
echo   WSL ディストリビューション内で以下を実行してください:
echo     sudo cp ~/.wsl/wsl.conf /etc/wsl.conf
echo   その後 WSL を再起動:
echo     wsl --shutdown
echo.
exit /b 0

REM ===== ヘルプ =====
:show_help
echo.
echo 使用方法: setup.bat [オプション]
echo.
echo オプション:
echo   --skip-nvim      Neovim のセットアップをスキップ
echo   --skip-plugins   Lazy.nvim プラグイン同期をスキップ
echo   --skip-wsl       WSL のセットアップをスキップ
echo   --only ^<list^>    指定コンポーネントのみ実行 (例: --only nvim,wsl)
echo                    有効な値: nvim, wsl
echo   --dry-run        実行内容を表示するだけで変更しない
echo   --help, -h       このヘルプを表示
echo.
echo 例:
echo   setup.bat
echo   setup.bat --dry-run
echo   setup.bat --only nvim
echo   setup.bat --only nvim,wsl --dry-run
echo   setup.bat --skip-nvim
echo   setup.bat --skip-wsl --dry-run
echo.
exit /b 0
