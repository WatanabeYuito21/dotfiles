#!/usr/bin/env bash

# 既存ファイルのバックアップ
backup_if_exists() {
    local target="$1"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        local backup_name="${target}.backup.$(date +%Y%m%d_%H%M%S)"
        mv "$target" "$backup_name"
        log_warn "既存の $target を $backup_name にバックアップしました"
    fi
}
