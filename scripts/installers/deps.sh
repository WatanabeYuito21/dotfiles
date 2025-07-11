#!/usr/bin/env bash

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

# 利用可能な設定を表示
show_available_configs() {
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
}
