#!/usr/bin/env bash
# test
set -e

DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"

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

# Neovim設定のセットアップ
setup_neovim() {
    setup_config "nvim" || exit 1
}

# tmux設定のセットアップ
setup_tmux() {
    setup_config "tmux"
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

    # tmux
    if ! command -v tmux &> /dev/null; then
        log_warn "tmux がインストールされていません（tmux設定は無視されます）"
    fi

    # Python3 (Neovim provider用)
    if ! command -v python3 &> /dev/null; then
        log_warn "Python3 がインストールされていません（一部機能が制限される可能性があります）"
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
}

# メイン実行部分
main() {
    log_info "dotfiles セットアップを開始します..."

    # 現在のディレクトリを確認
    log_info "現在のディレクトリ: $(pwd)"
    log_info "DOTFILES_DIR: $DOTFILES_DIR"

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
    echo ""

    # 依存関係チェック
    check_dependencies

    # 各設定のセットアップ
    setup_neovim
    setup_tmux

    # プラグインマネージャーのセットアップ
    setup_lazy
    setup_tpm

    # 推奨事項の表示
    show_recommendations

    log_info "セットアップが完了しました！"
}

# スクリプト実行
main "$@"
