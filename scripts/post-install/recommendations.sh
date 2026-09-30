#!/usr/bin/env bash
set -euo pipefail

show_recommendations() {
    log_step "セットアップ後の推奨事項:"
    echo ""

    if [[ -d "$DOTFILES_DIR/nvim" ]]; then
        echo "【Neovim】"
        echo "  • 初回の通常起動時に Mason が LSP サーバーを自動インストールします（状況は :Mason で確認）"
        echo "  • 次のツールが無いと該当サーバーは自動インストールの対象外です:"
        echo "    npm (pyright, ts_ls) / go (gopls) / pwsh (powershell_es)"
        echo ""
    fi

    if [[ -d "$DOTFILES_DIR/tmux" ]]; then
        echo "【tmux】"
        if command -v tmux &>/dev/null; then
            echo "  • Prefix + I でプラグインをインストール（tmux 起動後）"
            echo "  • Prefix キー: Ctrl-j"
        else
            echo "  • tmux をインストール: sudo apt install tmux"
        fi
        echo ""
    fi

    echo "【bash】"
    command -v pyenv &>/dev/null \
        || echo "  • pyenv をインストール: curl https://pyenv.run | bash"
    command -v cargo &>/dev/null \
        || echo "  • Rust をインストール: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
    command -v uv &>/dev/null \
        || echo "  • uv をインストール: curl -LsSf https://astral.sh/uv/install.sh | sh"
    command -v node &>/dev/null \
        || echo "  • Node.js をインストール: nvm install --lts"
    if ! command -v pwsh &>/dev/null; then
        echo "  • pwsh をインストール（PowerShell LSP に必要。WSL では appendWindowsPath=false"
        echo "    のため Windows 側の pwsh.exe は使えず、WSL 内にネイティブインストールが必要）:"
        echo "    https://learn.microsoft.com/powershell/scripting/install/install-ubuntu"
    fi
    echo ""

    if is_wsl && [[ -f "$HOME/.wsl/wsl.conf" ]]; then
        echo "【WSL】"
        echo "  • 設定を適用するには以下を実行してください:"
        if [[ -x "$HOME/.wsl/apply-wsl-config.sh" ]]; then
            echo "    sudo ~/.wsl/apply-wsl-config.sh （新しいシェルでは apply-wsl-config でも可）"
        else
            echo "    sudo cp ~/.wsl/wsl.conf /etc/wsl.conf"
        fi
        echo "    （PowerShell で） wsl --shutdown"
        echo ""
    fi
}
