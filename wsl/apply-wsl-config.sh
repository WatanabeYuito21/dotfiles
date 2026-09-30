#!/usr/bin/env bash

# WSL設定適用スクリプト
# このスクリプトは管理者権限で実行する必要があります

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_FILE="$SCRIPT_DIR/wsl.conf"
TARGET_FILE="/etc/wsl.conf"

echo "WSL設定を適用中..."
echo "ソース: $SOURCE_FILE"
echo "ターゲット: $TARGET_FILE"

# root権限チェック
if [ "$EUID" -ne 0 ]; then
    echo "エラー: このスクリプトは管理者権限で実行する必要があります"
    echo "使用方法: sudo $0"
    exit 1
fi

# 既存ファイルのバックアップ
if [ -f "$TARGET_FILE" ]; then
    BACKUP_NAME="${TARGET_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
    mv "$TARGET_FILE" "$BACKUP_NAME"
    echo "既存の設定を $BACKUP_NAME にバックアップしました"
fi

# 設定ファイルをコピー
cp "$SOURCE_FILE" "$TARGET_FILE"
echo "WSL設定ファイルを配置しました"

# パーミッション設定
chmod 644 "$TARGET_FILE"

echo "完了！WSLを再起動して設定を反映してください:"
echo "  PowerShell/コマンドプロンプト: wsl --shutdown"
