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
SELECTION_SPECIFIED=false

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

--only / --skip-* のいずれも指定しない場合、対話的にコンポーネントを選択します
（非対話環境では全コンポーネントをインストールします）
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
        --skip-nvim) SKIP_NVIM=true; SELECTION_SPECIFIED=true ;;
        --skip-tmux) SKIP_TMUX=true; SELECTION_SPECIFIED=true ;;
        --skip-bash) SKIP_BASH=true; SELECTION_SPECIFIED=true ;;
        --skip-wsl)  SKIP_WSL=true;  SELECTION_SPECIFIED=true ;;
        --dry-run)   DRY_RUN=true ;;
        --only)
            shift
            if [[ $# -eq 0 ]]; then
                log_error "--only に値が指定されていません"
                exit 1
            fi
            add_only_components "$1"
            SELECTION_SPECIFIED=true
            ;;
        --only=*)
            add_only_components "${1#--only=}"
            SELECTION_SPECIFIED=true
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

# 対話的にインストール対象コンポーネントを選択する。
# 選択結果は ONLY_COMPONENTS に格納される。
interactive_select() {
    log_info "インストールするコンポーネントを選択してください:"
    local i
    for i in "${!VALID_COMPONENTS[@]}"; do
        printf "  %d) %s\n" "$((i + 1))" "${VALID_COMPONENTS[$i]}" >&2
    done
    printf "\n番号をスペース/カンマ区切りで入力（例: 1 3）、'a' で全て、空 Enter で全て: " >&2

    local input
    read -r input || input=""
    input="${input//,/ }"

    if [[ -z "$input" || "$input" == "a" || "$input" == "all" ]]; then
        ONLY_COMPONENTS=("${VALID_COMPONENTS[@]}")
        log_info "全コンポーネントを選択しました: ${ONLY_COMPONENTS[*]}"
        return 0
    fi

    local token
    local -a selected=()
    for token in $input; do
        if [[ "$token" =~ ^[0-9]+$ ]] && ((token >= 1 && token <= ${#VALID_COMPONENTS[@]})); then
            selected+=("${VALID_COMPONENTS[$((token - 1))]}")
        else
            log_error "無効な選択です: $token"
            exit 1
        fi
    done

    if ((${#selected[@]} == 0)); then
        log_warn "コンポーネントが選択されませんでした。処理を終了します"
        exit 0
    fi

    ONLY_COMPONENTS=("${selected[@]}")
    log_info "選択したコンポーネント: ${ONLY_COMPONENTS[*]}"
}

main() {
    log_info "dotfiles セットアップを開始します (DOTFILES_DIR=$DOTFILES_DIR)"
    $DRY_RUN && log_warn "dry-run モード: 状態は変更されません"

    # 選択指定がない場合は対話的に選択（非対話環境では全インストール）
    if ! $SELECTION_SPECIFIED; then
        if [[ -t 0 ]]; then
            interactive_select
        else
            log_warn "非対話環境のため全コンポーネントをインストールします"
        fi
    fi

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
