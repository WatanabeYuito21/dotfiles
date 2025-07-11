#!/usr/bin/env bash

# Neovim設定のセットアップ
setup_neovim() {
    setup_config "nvim" || exit 1
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
