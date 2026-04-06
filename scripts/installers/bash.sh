#!/usr/bin/env bash
set -euo pipefail

setup_bash() {
    log_step "bash 設定をセットアップ中..."
    setup_home_config "bashrc" "$DOTFILES_DIR/bash/bashrc" "$HOME/.bashrc"
}
