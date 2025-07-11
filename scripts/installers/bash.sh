#!/usr/bin/env bash

# bash設定のセットアップ
setup_bash() {
    local source_file="$DOTFILES_DIR/bash/bashrc"
    local target_file="$HOME/.bashrc"

    setup_home_config "bash" "$source_file" "$target_file"

    # 追加の bash 設定ファイルがある場合も処理
    if [ -f "$DOTFILES_DIR/bash/bash_aliases" ]; then
        setup_home_config "bash_aliases" "$DOTFILES_DIR/bash/bash_aliases" "$HOME/.bash_aliases"
    fi

    if [ -f "$DOTFILES_DIR/bash/bash_profile" ]; then
        setup_home_config "bash_profile" "$DOTFILES_DIR/bash/bash_profile" "$HOME/.bash_profile"
    fi
}

# bash設定の再読み込み
reload_bash() {
    if [ -f "$HOME/.bashrc" ]; then
        log_info "bash設定を再読み込み中..."
        # 現在のシェルがbashの場合のみ再読み込み
        if [ "$BASH" ]; then
            source "$HOME/.bashrc"
            log_info "bash設定が再読み込みされました"
        else
            log_info "bash以外のシェルを使用中です。新しいターミナルを開くか、手動で 'source ~/.bashrc' を実行してください"
        fi
    fi
}
