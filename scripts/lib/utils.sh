#!/usr/bin/env bash

# グローバル変数の設定
init_environment() {
    # sudoで実行された場合、元のユーザーのホームディレクトリを使用
    if [ -n "$SUDO_USER" ]; then
        REAL_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
        export DOTFILES_DIR="$REAL_HOME/dotfiles"
        export CONFIG_DIR="$REAL_HOME/.config"
    else
        export DOTFILES_DIR="$HOME/dotfiles"
        export CONFIG_DIR="$HOME/.config"
    fi
    
    log_info "現在のディレクトリ: $(pwd)"
    log_info "DOTFILES_DIR: $DOTFILES_DIR"
    
    # dotfilesディレクトリの存在確認
    if [ ! -d "$DOTFILES_DIR" ]; then
        log_error "dotfiles ディレクトリが見つかりません: $DOTFILES_DIR"
        exit 1
    fi
}

# WSL環境検出
is_wsl() {
    [ -n "$WSL_DISTRO_NAME" ] || [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]
}

# 設定ファイルのリンク作成（汎用関数）
setup_config() {
    local config_name="$1"
    local source_dir="$DOTFILES_DIR/$config_name"
    local target_dir="$CONFIG_DIR/$config_name"

    log_info "$config_name 設定をセットアップ中..."
    log_info "ソースディレクトリ: $source_dir"
    log_info "ターゲットディレクトリ: $target_dir"

    # ソースディレクトリの存在確認
    if [ ! -d "$source_dir" ]; then
        log_warn "$config_name 設定ディレクトリが見つかりません: $source_dir"
        return 1
    fi

    # 既存のリンク/ディレクトリを処理
    if [ -L "$target_dir" ]; then
        log_info "既存のシンボリックリンクを削除: $target_dir"
        rm "$target_dir"
    elif [ -d "$target_dir" ]; then
        backup_if_exists "$target_dir"
    fi

    # .configディレクトリが存在しない場合は作成
    mkdir -p "$CONFIG_DIR"

    # シンボリックリンクを作成
    ln -sf "$source_dir" "$target_dir"

    # 結果を確認
    if [ -L "$target_dir" ]; then
        log_info "$config_name のシンボリックリンクを作成しました:"
        ls -la "$target_dir"
        log_info "リンク先: $(readlink $target_dir)"
        return 0
    else
        log_error "$config_name のシンボリックリンクの作成に失敗しました"
        return 1
    fi
}

# ホームディレクトリ設定ファイルのリンク作成
setup_home_config() {
    local config_name="$1"
    local source_file="$2"
    local target_file="$3"

    log_info "$config_name 設定をセットアップ中..."
    log_info "ソースファイル: $source_file"
    log_info "ターゲットファイル: $target_file"

    # ソースファイルの存在確認
    if [ ! -f "$source_file" ]; then
        log_warn "$config_name 設定ファイルが見つかりません: $source_file"
        return 1
    fi

    # 既存のファイル/リンクを処理
    if [ -L "$target_file" ]; then
        log_info "既存のシンボリックリンクを削除: $target_file"
        rm "$target_file"
    elif [ -f "$target_file" ]; then
        backup_if_exists "$target_file"
    fi

    # シンボリックリンクを作成
    ln -sf "$source_file" "$target_file"

    # 結果を確認
    if [ -L "$target_file" ]; then
        log_info "$config_name のシンボリックリンクを作成しました:"
        ls -la "$target_file"
        log_info "リンク先: $(readlink $target_file)"
        return 0
    else
        log_error "$config_name のシンボリックリンクの作成に失敗しました"
        return 1
    fi
}
