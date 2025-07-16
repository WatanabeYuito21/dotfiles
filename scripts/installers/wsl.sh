#!/usr/bin/env bash

# ユーザー空間でのWSL設定管理
setup_wsl() {
    if ! is_wsl; then
        log_info "WSL環境ではないため、WSL設定をスキップします"
        return 0
    fi

    local source_file="$DOTFILES_DIR/wsl/wsl.conf"
    local user_wsl_dir="$HOME/.wsl"
    local user_wsl_conf="$user_wsl_dir/wsl.conf"
    local setup_script="$user_wsl_dir/apply-wsl-config.sh"

    log_info "WSL設定をユーザー空間で準備中..."

    # ソースファイルの存在確認
    if [ ! -f "$source_file" ]; then
        log_warn "WSL設定ファイルが見つかりません: $source_file"
        return 1
    fi

    # ユーザー用WSLディレクトリを作成
    mkdir -p "$user_wsl_dir"

    # WSL設定ファイルをユーザー空間にコピー
    cp "$source_file" "$user_wsl_conf"
    log_info "WSL設定ファイルをユーザー空間にコピーしました: $user_wsl_conf"

    # WSL設定適用スクリプトを生成
    cat > "$setup_script" << 'EOF'
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
EOF

    chmod +x "$setup_script"

    # .bashrcに便利なエイリアスを追加（既に存在しない場合のみ）
    add_wsl_alias "$setup_script"

    log_info "WSL設定の準備が完了しました"
    return 0
}

# .bashrcにWSL設定適用エイリアスを追加
add_wsl_alias() {
    local setup_script="$1"
    local bashrc_file="$HOME/.bashrc"
    
    if [ -f "$bashrc_file" ] && ! grep -q "apply-wsl-config" "$bashrc_file"; then
        echo "" >> "$bashrc_file"
        echo "# WSL設定適用エイリアス（dotfilesセットアップで自動追加）" >> "$bashrc_file"
        echo "alias apply-wsl-config='sudo \"$setup_script\"'" >> "$bashrc_file"
        log_info "便利なエイリアス 'apply-wsl-config' を .bashrc に追加しました"
    fi
}
