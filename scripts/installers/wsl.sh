#!/usr/bin/env bash
set -euo pipefail

setup_wsl() {
    if ! is_wsl; then
        log_info "WSL 環境ではないため、WSL 設定をスキップします"
        return 0
    fi

    log_step "WSL 設定をセットアップ中..."

    local src="$DOTFILES_DIR/wsl/wsl.conf"

    if [[ ! -f "$src" ]]; then
        log_warn "WSL 設定ファイルが見つかりません: $src"
        return 0
    fi

    run_cmd mkdir -p "$HOME/.wsl"
    run_cmd cp "$src" "$HOME/.wsl/wsl.conf"
    log_info "WSL 設定を ~/.wsl/wsl.conf にコピーしました"
    log_info "適用するには: sudo cp ~/.wsl/wsl.conf /etc/wsl.conf && wsl --shutdown"
}
