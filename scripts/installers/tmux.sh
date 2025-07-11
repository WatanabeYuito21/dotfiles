#!/usr/bin/env bash

# tmux設定のセットアップ
setup_tmux() {
    setup_config "tmux"
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
