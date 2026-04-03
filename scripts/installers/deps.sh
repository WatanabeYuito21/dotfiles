#!/usr/bin/env bash

check_dependencies() {
    log_step "依存関係をチェック中..."

    # 必須
    local missing=false
    for cmd in git nvim; do
        if ! command -v "$cmd" &>/dev/null; then
            log_error "$cmd がインストールされていません（必須）"
            missing=true
        fi
    done
    $missing && { log_error "必須依存関係が不足しています。インストール後に再実行してください"; exit 1; }

    # オプション
    for cmd in tmux python3 pyenv cargo node uv; do
        command -v "$cmd" &>/dev/null || log_warn "$cmd が見つかりません（オプション）"
    done

    log_info "依存関係チェック完了"
}
