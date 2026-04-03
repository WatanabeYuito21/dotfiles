#!/usr/bin/env bash

setup_bash() {
    log_step "bash 設定をセットアップ中..."
    setup_home_config "bashrc" "$DOTFILES_DIR/bash/bashrc" "$HOME/.bashrc"
}
