#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

source "$SCRIPT_DIR/lib/logger.sh"
source "$SCRIPT_DIR/lib/backup.sh"
source "$SCRIPT_DIR/lib/utils.sh"

source "$SCRIPT_DIR/installers/deps.sh"
source "$SCRIPT_DIR/installers/nvim.sh"
source "$SCRIPT_DIR/installers/tmux.sh"
source "$SCRIPT_DIR/installers/bash.sh"
source "$SCRIPT_DIR/installers/wsl.sh"

source "$SCRIPT_DIR/post-install/plugins.sh"
source "$SCRIPT_DIR/post-install/recommendations.sh"

# フラグの解析
SKIP_NVIM=false
SKIP_TMUX=false
SKIP_BASH=false
SKIP_WSL=false

for arg in "$@"; do
    case "$arg" in
        --skip-nvim) SKIP_NVIM=true ;;
        --skip-tmux) SKIP_TMUX=true ;;
        --skip-bash) SKIP_BASH=true ;;
        --skip-wsl)  SKIP_WSL=true ;;
        --help|-h)
            echo "Usage: $0 [--skip-nvim] [--skip-tmux] [--skip-bash] [--skip-wsl]"
            exit 0
            ;;
        *)
            log_error "不明な引数: $arg"
            exit 1
            ;;
    esac
done

main() {
    log_info "dotfiles セットアップを開始します (DOTFILES_DIR=$DOTFILES_DIR)"

    check_dependencies

    $SKIP_NVIM || setup_neovim
    $SKIP_TMUX || setup_tmux
    $SKIP_BASH || setup_bash
    $SKIP_WSL  || setup_wsl

    setup_plugins

    show_recommendations

    log_info "セットアップが完了しました！新しいターミナルを開くか 'source ~/.bashrc' を実行してください"
}

main
