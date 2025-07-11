#!/usr/bin/env bash
# test
set -e

# sudoで実行された場合、元のユーザーのホームディレクトリを使用
if [ -n "$SUDO_USER" ]; then
    REAL_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
    DOTFILES_DIR="$REAL_HOME/dotfiles"
    CONFIG_DIR="$REAL_HOME/.config"
else
    DOTFILES_DIR="$HOME/dotfiles"
    CONFIG_DIR="$HOME/.config"
fi

# 色付きログ出力
log_info() {
    echo -e "\033[32m[INFO]\033[0m $1"
}

log_warn() {
    echo -e "\033[33m[WARN]\033[0m $1"
}

log_error() {
    echo -e "\033[31m[ERROR]\033[0m $1"
}

# 既存ファイルのバックアップ
backup_if_exists() {
    local target="$1"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        local backup_name="${target}.backup.$(date +%Y%m%d_%H%M%S)"
        mv "$target" "$backup_name"
        log_warn "既存の $target を $backup_name にバックアップしました"
    fi
}

# 設定ファイルのリンク作成（汎用関数）
setup_config() {
    local config_name="$1"
    local source_dir="$DOTFILES_DIR/$config_name"
    local target_dir="$CONFIG_DIR/$config_name"

    log_info "$config_name 設定をセットアップ中..."
    log_info "ソースディレクトリ: $source_dir"
    log_info "ターゲットディレクトリ: $target_dir"

    # ソースディレクトリの存在確認
    if [ ! -d "$source_dir" ]; then
        log_warn "$config_name 設定ディレクトリが見つかりません: $source_dir"
        return 1
    fi

    # 既存のリンク/ディレクトリを処理
    if [ -L "$target_dir" ]; then
        log_info "既存のシンボリックリンクを削除: $target_dir"
        rm "$target_dir"
    elif [ -d "$target_dir" ]; then
        backup_if_exists "$target_dir"
    fi

    # .configディレクトリが存在しない場合は作成
    mkdir -p "$CONFIG_DIR"

    # シンボリックリンクを作成
    ln -sf "$source_dir" "$target_dir"

    # 結果を確認
    if [ -L "$target_dir" ]; then
        log_info "$config_name のシンボリックリンクを作成しました:"
        ls -la "$target_dir"
        log_info "リンク先: $(readlink $target_dir)"
        return 0
    else
        log_error "$config_name のシンボリックリンクの作成に失敗しました"
        return 1
    fi
}

# ホームディレクトリ設定ファイルのリンク作成
setup_home_config() {
    local config_name="$1"
    local source_file="$2"
    local target_file="$3"

    log_info "$config_name 設定をセットアップ中..."
    log_info "ソースファイル: $source_file"
    log_info "ターゲットファイル: $target_file"

    # ソースファイルの存在確認
    if [ ! -f "$source_file" ]; then
        log_warn "$config_name 設定ファイルが見つかりません: $source_file"
        return 1
    fi

    # 既存のファイル/リンクを処理
    if [ -L "$target_file" ]; then
        log_info "既存のシンボリックリンクを削除: $target_file"
        rm "$target_file"
    elif [ -f "$target_file" ]; then
        backup_if_exists "$target_file"
    fi

    # シンボリックリンクを作成
    ln -sf "$source_file" "$target_file"

    # 結果を確認
    if [ -L "$target_file" ]; then
        log_info "$config_name のシンボリックリンクを作成しました:"
        ls -la "$target_file"
        log_info "リンク先: $(readlink $target_file)"
        return 0
    else
        log_error "$config_name のシンボリックリンクの作成に失敗しました"
        return 1
    fi
}

# WSL環境検出
is_wsl() {
    [ -n "$WSL_DISTRO_NAME" ] || [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]
}

# WSL設定のセットアップ
setup_wsl() {
    if ! is_wsl; then
        log_info "WSL環境ではないため、WSL設定をスキップします"
        return 0
    fi

    local source_file="$DOTFILES_DIR/wsl/wsl.conf"
    local target_file="/etc/wsl.conf"

    log_info "WSL設定をセットアップ中..."
    log_info "ソースファイル: $source_file"
    log_info "ターゲットファイル: $target_file"

    # ソースファイルの存在確認
    if [ ! -f "$source_file" ]; then
        log_warn "WSL設定ファイルが見つかりません: $source_file"
        return 1
    fi

    # 既に root 権限で実行されている場合
    if [ "$EUID" -eq 0 ]; then
        # 既存ファイルのバックアップ
        if [ -f "$target_file" ] && [ ! -L "$target_file" ]; then
            local backup_name="${target_file}.backup.$(date +%Y%m%d_%H%M%S)"
            mv "$target_file" "$backup_name"
            log_warn "既存の $target_file を $backup_name にバックアップしました"
        fi

        # WSL設定ファイルをコピー
        cp "$source_file" "$target_file"
    else
        # sudo権限の確認
        if ! sudo -n true 2>/dev/null; then
            log_warn "sudo権限が必要です。WSL設定のセットアップにはroot権限が必要です"
            echo "WSL設定を手動でセットアップする場合:"
            echo "  sudo cp $source_file $target_file"
            return 1
        fi

        # 既存ファイルのバックアップ（sudo権限で）
        if [ -f "$target_file" ] && [ ! -L "$target_file" ]; then
            local backup_name="${target_file}.backup.$(date +%Y%m%d_%H%M%S)"
            sudo mv "$target_file" "$backup_name"
            log_warn "既存の $target_file を $backup_name にバックアップしました"
        fi

        # WSL設定ファイルをコピー
        sudo cp "$source_file" "$target_file"
    fi

    # 結果を確認
    if [ -f "$target_file" ]; then
        log_info "WSL設定ファイルを配置しました:"
        ls -la "$target_file"
        log_info "設定を反映するにはWSLを再起動してください"
        return 0
    else
        log_error "WSL設定ファイルの配置に失敗しました"
        return 1
    fi
}

# Neovim設定のセットアップ
setup_neovim() {
    setup_config "nvim" || exit 1
}

# tmux設定のセットアップ
setup_tmux() {
    setup_config "tmux"
}

# bash設定のセットアップ
setup_bash() {
    local source_file="$DOTFILES_DIR/bash/bashrc"
    local target_file="$HOME/.bashrc"

    setup_home_config "bash" "$source_file" "$target_file"

    # 追加の bash 設定ファイルがある場合も処理
    if [ -f "$DOTFILES_DIR/bash/bash_aliases" ]; then
        setup_home_config "bash_aliases" "$DOTFILES_DIR/bash/bash_aliases" "$HOME/.bash_aliases"
    fi

    if [ -f "$DOTFILES_DIR/bash/bash_profile" ]; then
        setup_home_config "bash_profile" "$DOTFILES_DIR/bash/bash_profile" "$HOME/.bash_profile"
    fi
}

# 依存関係のチェック
check_dependencies() {
    log_info "依存関係をチェック中..."

    # Neovim
    if ! command -v nvim &> /dev/null; then
        log_error "Neovim がインストールされていません"
        exit 1
    fi

    # Git
    if ! command -v git &> /dev/null; then
        log_error "Git がインストールされていません"
        exit 1
    fi

    # bash
    if ! command -v bash &> /dev/null; then
        log_error "bash がインストールされていません"
        exit 1
    fi

    # tmux
    if ! command -v tmux &> /dev/null; then
        log_warn "tmux がインストールされていません（tmux設定は無視されます）"
    fi

    # Python3 (Neovim provider用)
    if ! command -v python3 &> /dev/null; then
        log_warn "Python3 がインストールされていません（一部機能が制限される可能性があります）"
    fi

    # pyenv
    if ! command -v pyenv &> /dev/null; then
        log_warn "pyenv がインストールされていません（Python バージョン管理が使用できません）"
    fi

    # cargo
    if ! command -v cargo &> /dev/null; then
        log_warn "Cargo がインストールされていません（Rust 開発環境が使用できません）"
    fi

    # Node.js (一部プラグイン用)
    if ! command -v node &> /dev/null; then
        log_warn "Node.js がインストールされていません（Markdown preview等が動作しない可能性があります）"
    fi

    log_info "依存関係チェック完了"
}

# Lazy.nvimの初期化
setup_lazy() {
    if [ ! -d "$DOTFILES_DIR/nvim" ]; then
        log_warn "Neovim設定が見つからないため、Lazy.nvimセットアップをスキップします"
        return
    fi

    log_info "Lazy.nvim プラグインマネージャーを初期化中..."

    # Neovimを起動してプラグインをインストール
    nvim --headless "+Lazy! sync" +qa

    log_info "プラグインのインストールが完了しました"
}

# tmux plugin manager のセットアップ
setup_tpm() {
    if [ ! -d "$DOTFILES_DIR/tmux" ]; then
        log_warn "tmux設定が見つからないため、TPMセットアップをスキップします"
        return
    fi

    log_info "tmux plugin manager (TPM) をセットアップ中..."

    local tpm_dir="$HOME/.tmux/plugins/tpm"

    # TPMがまだインストールされていない場合
    if [ ! -d "$tpm_dir" ]; then
        log_info "TPMをインストール中..."
        git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
    else
        log_info "TPMは既にインストールされています"
    fi

    # tmuxが動作中の場合、プラグインをインストール
    if command -v tmux &> /dev/null; then
        if tmux list-sessions &> /dev/null 2>&1; then
            log_info "tmuxプラグインをインストール中..."
            "$tpm_dir/scripts/install_plugins.sh"
        else
            log_info "tmuxセッションが見つかりません。手動でプラグインをインストールしてください:"
            echo "  tmux起動後に Prefix + I を押してプラグインをインストール"
        fi
    fi
}

# bash設定の再読み込み
reload_bash() {
    if [ -f "$HOME/.bashrc" ]; then
        log_info "bash設定を再読み込み中..."
        # 現在のシェルがbashの場合のみ再読み込み
        if [ "$BASH" ]; then
            source "$HOME/.bashrc"
            log_info "bash設定が再読み込みされました"
        else
            log_info "bash以外のシェルを使用中です。新しいターミナルを開くか、手動で 'source ~/.bashrc' を実行してください"
        fi
    fi
}

# 推奨事項の表示
show_recommendations() {
    log_info "セットアップ後の推奨事項:"
    echo ""
    echo "【Neovim】"
    echo "  • LSPサーバーをインストール: :Mason"
    echo "  • 推奨LSPサーバー:"
    echo "    - Lua: lua-language-server"
    echo "    - Python: pyright"
    echo "    - TypeScript/JavaScript: typescript-language-server"
    echo "    - Rust: rust-analyzer"
    echo "    - Go: gopls"
    echo "    - PowerShell: PowerShell Editor Services"
    echo "    - Markdown: marksman"
    echo ""

    if [ -d "$DOTFILES_DIR/tmux" ]; then
        echo "【tmux】"
        if command -v tmux &> /dev/null; then
            echo "  • tmux起動後に Prefix + I でプラグインをインストール"
            echo "  • Prefix キーは Ctrl-j に設定されています"
            echo "  • vim風のキーバインドが設定されています"
        else
            echo "  • tmuxをインストールしてください: sudo apt install tmux"
        fi
        echo ""
    fi

    if [ -f "$DOTFILES_DIR/bash/bashrc" ]; then
        echo "【bash】"
        echo "  • 履歴共有機能が有効になっています"
        echo "  • pyenv が設定されています（Python バージョン管理）"
        echo "  • Cargo が設定されています（Rust 開発環境）"
        echo "  • WSL2 サポートが含まれています"
        if ! command -v pyenv &> /dev/null; then
            echo "  • pyenv をインストールすることをお勧めします:"
            echo "    curl https://pyenv.run | bash"
        fi
        if ! command -v cargo &> /dev/null; then
            echo "  • Rust をインストールすることをお勧めします:"
            echo "    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
        fi
        echo ""
    fi

    if is_wsl && [ -f "$DOTFILES_DIR/wsl/wsl.conf" ]; then
        echo "【WSL】"
        echo "  • WSL設定が適用されました"
        echo "  • 設定を完全に反映するには以下を実行してください:"
        echo "    PowerShell/コマンドプロンプト: wsl --shutdown"
        echo "    その後、WSLを再起動してください"
        echo ""
    fi
}

# メイン実行部分
main() {
    log_info "dotfiles セットアップを開始します..."

    # 現在のディレクトリを確認
    log_info "現在のディレクトリ: $(pwd)"
    log_info "DOTFILES_DIR: $DOTFILES_DIR"

    # WSL環境の検出
    if is_wsl; then
        log_info "WSL環境を検出しました: $WSL_DISTRO_NAME"
    fi

    # dotfilesディレクトリの存在確認
    if [ ! -d "$DOTFILES_DIR" ]; then
        log_error "dotfiles ディレクトリが見つかりません: $DOTFILES_DIR"
        exit 1
    fi

    # 利用可能な設定を表示
    log_info "利用可能な設定:"
    if [ -d "$DOTFILES_DIR/nvim" ]; then
        echo "  ✓ Neovim設定"
    else
        echo "  ✗ Neovim設定"
    fi

    if [ -d "$DOTFILES_DIR/tmux" ]; then
        echo "  ✓ tmux設定"
    else
        echo "  ✗ tmux設定"
    fi

    if [ -f "$DOTFILES_DIR/bash/bashrc" ]; then
        echo "  ✓ bash設定"
    else
        echo "  ✗ bash設定"
    fi

    if is_wsl && [ -f "$DOTFILES_DIR/wsl/wsl.conf" ]; then
        echo "  ✓ WSL設定"
    elif is_wsl; then
        echo "  ✗ WSL設定"
    fi
    echo ""

    # 依存関係チェック
    check_dependencies

    # 各設定のセットアップ
    setup_neovim
    setup_tmux
    setup_bash
    setup_wsl

    # bash設定の再読み込み
    reload_bash

    # プラグインマネージャーのセットアップ
    setup_lazy
    setup_tpm

    # 推奨事項の表示
    show_recommendations

    log_info "セットアップが完了しました！"
}

# スクリプト実行
main "$@"
