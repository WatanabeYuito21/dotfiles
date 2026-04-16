#!/usr/bin/env bash
set -euo pipefail

# 既存ファイルのバックアップ
backup_if_exists() {
    local target="$1"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        local backup_name="${target}.backup.$(date +%Y%m%d_%H%M%S)"
        run_cmd mv "$target" "$backup_name"
        log_warn "既存の $target を $backup_name にバックアップしました"
    fi
}
