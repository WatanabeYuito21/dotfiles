#!/usr/bin/env bash

# WSL設定のセットアップ
setup_wsl() {
    if ! is_wsl; then
        log_info "WSL環境ではないため、WSL設定をスキップします"
        return 0
    fi

    local source_file="$DOTFILES_DIR/wsl/wsl.conf"
    local target_file="/etc/wsl.conf"

    log_info "WSL設定をセットアップ中..."
    log_info "ソースファイル: $source_file"
    log_info "ターゲットファイル: $target_file"

    # ソースファイルの存在確認
    if [ ! -f "$source_file" ]; then
        log_warn "WSL設定ファイルが見つかりません: $source_file"
        return 1
    fi

    # 既に root 権限で実行されている場合
    if [ "$EUID" -eq 0 ]; then
        # 既存ファイルのバックアップ
        if [ -f "$target_file" ] && [ ! -L "$target_file" ]; then
            local backup_name="${target_file}.backup.$(date +%Y%m%d_%H%M%S)"
            mv "$target_file" "$backup_name"
            log_warn "既存の $target_file を $backup_name にバックアップしました"
        fi

        # WSL設定ファイルをコピー
        cp "$source_file" "$target_file"
    else
        # sudo権限の確認
        if ! sudo -n true 2>/dev/null; then
            log_warn "sudo権限が必要です。WSL設定のセットアップにはroot権限が必要です"
            echo "WSL設定を手動でセットアップする場合:"
            echo "  sudo cp $source_file $target_file"
            return 1
        fi

        # 既存ファイルのバックアップ（sudo権限で）
        if [ -f "$target_file" ] && [ ! -L "$target_file" ]; then
            local backup_name="${target_file}.backup.$(date +%Y%m%d_%H%M%S)"
            sudo mv "$target_file" "$backup_name"
            log_warn "既存の $target_file を $backup_name にバックアップしました"
        fi

        # WSL設定ファイルをコピー
        sudo cp "$source_file" "$target_file"
    fi

    # 結果を確認
    if [ -f "$target_file" ]; then
        log_info "WSL設定ファイルを配置しました:"
        ls -la "$target_file"
        log_info "設定を反映するにはWSLを再起動してください"
        return 0
    else
        log_error "WSL設定ファイルの配置に失敗しました"
        return 1
    fi
}
