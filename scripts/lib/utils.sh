#!/usr/bin/env bash

# WSL環境検出
is_wsl() {
    [[ -n "${WSL_DISTRO_NAME:-}" ]] || [[ -f /proc/sys/fs/binfmt_misc/WSLInterop ]]
}

# ~/.config/<name> へのシンボリックリンク作成
setup_config() {
    local name="$1"
    local src="$DOTFILES_DIR/$name"
    local dst="${XDG_CONFIG_HOME:-$HOME/.config}/$name"

    if [[ ! -d "$src" ]]; then
        log_warn "$name: ソースディレクトリが見つかりません: $src"
        return 0
    fi

    mkdir -p "$(dirname "$dst")"

    [[ -L "$dst" ]] && rm "$dst"
    [[ -d "$dst" ]] && backup_if_exists "$dst"

    ln -sf "$src" "$dst"
    log_info "$name: リンク作成 $dst -> $src"
}

# ホームディレクトリへのシンボリックリンク作成
setup_home_config() {
    local name="$1" src="$2" dst="$3"

    if [[ ! -f "$src" ]]; then
        log_warn "$name: ソースファイルが見つかりません: $src"
        return 0
    fi

    [[ -L "$dst" ]] && rm "$dst"
    [[ -f "$dst" ]] && backup_if_exists "$dst"

    ln -sf "$src" "$dst"
    log_info "$name: リンク作成 $dst -> $src"
}
