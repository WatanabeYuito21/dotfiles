# WSL2 / X11 設定

# WSL2 Interop修正関数
fix_wsl2_interop() {
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
    # WSL2の場合：Windows HostのIPを動的に取得
    if [[ $(uname -r) =~ microsoft ]]; then
        # WSL2: WSLg (ネイティブWSL GUI) を利用
        export DISPLAY=:0
    else
        # WSL1の場合
        export DISPLAY=localhost:0.0
    fi

    # WSL2 Interop修正を実行
    fix_wsl2_interop
elif [[ -n "$SSH_CONNECTION" ]]; then
    # SSH接続時はX11フォワーディングの設定をそのまま使用
    # DISPLAYは変更しない（SSHが自動設定）
    :
else
    # ネイティブLinux環境では通常設定をそのまま使用
    # DISPLAYは変更しない
    :
fi
