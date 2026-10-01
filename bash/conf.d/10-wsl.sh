# WSL / X11 設定

# WSL Interop修正関数 (WSL2以降)
fix_wsl_interop() {
    command -v pstree &>/dev/null || return 0
    for i in $(pstree -np -s $$ | grep -o -E '[0-9]+'); do
        if [[ -e "/run/WSL/${i}_interop" ]]; then
            export WSL_INTEROP=/run/WSL/${i}_interop
        fi
    done
}

# WSL設定適用エイリアス（setup.sh の wsl コンポーネントが ~/.wsl/ に配置する）
[ -x "$HOME/.wsl/apply-wsl-config.sh" ] && alias apply-wsl-config='sudo "$HOME/.wsl/apply-wsl-config.sh"'

# WSL環境での自動DISPLAY設定
if [[ -n "$WSL_DISTRO_NAME" ]]; then
    # WSL1 のカーネル名は "...-Microsoft"（大文字）。それ以外 (WSL2/WSL3 以降) は WSLg を利用
    if [[ $(uname -r) =~ -Microsoft$ ]]; then
        # WSL1
        export DISPLAY=localhost:0.0
    else
        # WSL2以降: WSLg (ネイティブWSL GUI) を利用
        export DISPLAY=:0
    fi

    # WSL Interop修正を実行
    fix_wsl_interop
elif [[ -n "$SSH_CONNECTION" ]]; then
    # SSH接続時はX11フォワーディングの設定をそのまま使用
    # DISPLAYは変更しない（SSHが自動設定）
    :
else
    # ネイティブLinux環境では通常設定をそのまま使用
    # DISPLAYは変更しない
    :
fi
