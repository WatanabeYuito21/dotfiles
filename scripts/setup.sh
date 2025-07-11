#!/usr/bin/env bash
set -e

# スクリプトのディレクトリを取得
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ライブラリを読み込み
source "$SCRIPT_DIR/lib/utils.sh"
source "$SCRIPT_DIR/lib/logger.sh"
source "$SCRIPT_DIR/lib/backup.sh"

# インストーラーを読み込み
source "$SCRIPT_DIR/installers/deps.sh"
source "$SCRIPT_DIR/installers/nvim.sh"
source "$SCRIPT_DIR/installers/tmux.sh"
source "$SCRIPT_DIR/installers/bash.sh"
source "$SCRIPT_DIR/installers/wsl.sh"

# ポストインストールスクリプトを読み込み
source "$SCRIPT_DIR/post-install/plugins.sh"
source "$SCRIPT_DIR/post-install/recommendations.sh"

# メイン実行関数
main() {
    log_info "dotfiles セットアップを開始します..."
    
    # 初期化
    init_environment
    
    # 依存関係チェック
    check_dependencies
    
    # 各設定のセットアップ
    setup_neovim
    setup_tmux
    setup_bash
    setup_wsl
    
    # bash設定の再読み込み
    reload_bash
    
    # プラグインマネージャーのセットアップ
    setup_plugins
    
    # 推奨事項の表示
    show_recommendations
    
    log_info "セットアップが完了しました！"
}

main "$@"
