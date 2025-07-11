#!/usr/bin/env bash
set -e

# スクリプトのディレクトリを取得（プロジェクトルート）
DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_DIR="$DOTFILES_ROOT/scripts"

# scriptsディレクトリの存在確認
if [ ! -d "$SCRIPT_DIR" ]; then
    echo "Error: scripts directory not found at $SCRIPT_DIR"
    echo "Please run this script from the dotfiles project root."
    exit 1
fi

# 実際のセットアップスクリプトを実行
exec "$SCRIPT_DIR/setup.sh" "$@"
