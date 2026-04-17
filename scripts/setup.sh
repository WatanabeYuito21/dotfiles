#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"; export DOTFILES_DIR

source "$SCRIPT_DIR/lib/logger.sh"
source "$SCRIPT_DIR/lib/backup.sh"
source "$SCRIPT_DIR/lib/utils.sh"

source "$SCRIPT_DIR/installers/deps.sh"
source "$SCRIPT_DIR/installers/nvim.sh"
source "$SCRIPT_DIR/installers/tmux.sh"
source "$SCRIPT_DIR/installers/bash.sh"
source "$SCRIPT_DIR/installers/wsl.sh"

source "$SCRIPT_DIR/post-install/recommendations.sh"

VALID_COMPONENTS=(nvim tmux bash wsl)

SKIP_NVIM=false
SKIP_TMUX=false
SKIP_BASH=false
SKIP_WSL=false
DRY_RUN=false
ONLY_COMPONENTS=()

usage() {
    cat <<EOF
Usage: $0 [options]

Options:
  --skip-nvim                     nvim 設定をスキップ
  --skip-tmux                     tmux 設定をスキップ
  --skip-bash                     bash 設定をスキップ
  --skip-wsl                      WSL 設定をスキップ
  --only <comp>[,<comp>...]       指定したコンポーネントのみ実行
  --only=<comp>[,<comp>...]       同上（= 区切り）
  --dry-run                       状態を変更せず実行内容のみ表示
  -h, --help                      このヘルプを表示

Components: ${VALID_COMPONENTS[*]}

--only は繰り返し指定可能（例: --only nvim --only tmux）
--only と --skip-* の併用はエラーとなります
EOF
}

is_valid_component() {
    local comp="$1"
    local valid
    for valid in "${VALID_COMPONENTS[@]}"; do
        [[ "$comp" == "$valid" ]] && return 0
    done
    return 1
}

add_only_components() {
    local value="$1"
    local IFS=','
    local comp
    for comp in $value; do
        if ! is_valid_component "$comp"; then
            log_error "--only の値が不正です: $comp (有効: ${VALID_COMPONENTS[*]})"
            exit 1
        fi
        ONLY_COMPONENTS+=("$comp")
    done
}

while (($#)); do
    case "$1" in
        --skip-nvim) SKIP_NVIM=true ;;
        --skip-tmux) SKIP_TMUX=true ;;
        --skip-bash) SKIP_BASH=true ;;
        --skip-wsl)  SKIP_WSL=true ;;
        --dry-run)   DRY_RUN=true ;;
        --only)
            shift
            if [[ $# -eq 0 ]]; then
                log_error "--only に値が指定されていません"
                exit 1
            fi
            add_only_components "$1"
            ;;
        --only=*)
            add_only_components "${1#--only=}"
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        *)
            log_error "不明な引数: $1"
            usage >&2
            exit 1
            ;;
    esac
    shift
done

# --only と --skip-* の併用チェック
if ((${#ONLY_COMPONENTS[@]} > 0)); then
    if $SKIP_NVIM || $SKIP_TMUX || $SKIP_BASH || $SKIP_WSL; then
        log_error "--only と --skip-* は併用できません"
        exit 1
    fi
fi

export DRY_RUN

should_run() {
    local comp="$1"
    if ((${#ONLY_COMPONENTS[@]} > 0)); then
        local c
        for c in "${ONLY_COMPONENTS[@]}"; do
            [[ "$c" == "$comp" ]] && return 0
        done
        return 1
    fi
    case "$comp" in
        nvim) $SKIP_NVIM && return 1 || return 0 ;;
        tmux) $SKIP_TMUX && return 1 || return 0 ;;
        bash) $SKIP_BASH && return 1 || return 0 ;;
        wsl)  $SKIP_WSL  && return 1 || return 0 ;;
    esac
    return 1
}

main() {
    log_info "dotfiles セットアップを開始します (DOTFILES_DIR=$DOTFILES_DIR)"
    $DRY_RUN && log_warn "dry-run モード: 状態は変更されません"

    check_dependencies

    if should_run nvim; then
        setup_neovim
        setup_lazy
    fi

    if should_run tmux; then
        setup_tmux
        setup_tpm
    fi

    should_run bash && setup_bash
    should_run wsl  && setup_wsl

    show_recommendations

    log_info "セットアップが完了しました！新しいターミナルを開くか 'source ~/.bashrc' を実行してください"
}

main
