#!/usr/bin/env bash
set -euo pipefail

setup_tmux() {
    log_step "tmux 設定をセットアップ中..."
    setup_config "tmux"
}

setup_tpm() {
    if [[ ! -d "$DOTFILES_DIR/tmux" ]]; then
        log_warn "tmux 設定が見つかりません。TPM セットアップをスキップします"
        return
    fi

    local tpm_dir="$HOME/.tmux/plugins/tpm"

    if [[ ! -d "$tpm_dir" ]]; then
        log_info "TPM をインストール中..."
        if ! run_cmd git clone https://github.com/tmux-plugins/tpm "$tpm_dir"; then
            log_warn "TPM のクローンに失敗しました。ネットワークを確認してください"
            return 0
        fi
    else
        log_info "TPM は既にインストールされています"
    fi

    if command -v tmux &>/dev/null && tmux list-sessions &>/dev/null 2>&1; then
        log_info "tmux プラグインをインストール中..."
        run_cmd "$tpm_dir/scripts/install_plugins.sh"
    else
        log_info "tmux が起動していません。起動後に Prefix + I でプラグインをインストールしてください"
    fi
}
