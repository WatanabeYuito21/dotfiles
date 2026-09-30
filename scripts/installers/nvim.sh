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
    if [[ "$DRY_RUN" == "true" ]]; then
        run_cmd nvim --headless "+Lazy! sync" +qa
        return 0
    fi

    local log_file
    log_file="$(mktemp "${TMPDIR:-/tmp}/lazy-sync.XXXXXX.log")"
    if nvim --headless "+Lazy! sync" +qa >"$log_file" 2>&1; then
        rm -f "$log_file"
    else
        log_warn "Lazy sync に失敗しました。起動後に :Lazy sync を実行してください（ログ: $log_file）"
        tail -n 10 "$log_file" >&2 || true
    fi
}
