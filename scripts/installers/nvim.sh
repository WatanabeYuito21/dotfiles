#!/usr/bin/env bash
set -euo pipefail

setup_neovim() {
    log_step "Neovim 設定をセットアップ中..."
    setup_config "nvim"
}

setup_lazy() {
    if [[ ! -d "$DOTFILES_DIR/nvim" ]]; then
        log_warn "Neovim 設定が見つかりません。Lazy.nvim セットアップをスキップします"
        return
    fi

    log_info "Lazy.nvim プラグインを同期中..."
    run_cmd nvim --headless "+Lazy! sync" +qa 2>/dev/null \
        || log_warn "Lazy sync に失敗しました。起動後に :Lazy sync を実行してください"
}
