#!/usr/bin/env bash
set -euo pipefail

show_recommendations() {
    log_step "セットアップ後の推奨事項:"
    echo ""

    if [[ -d "$DOTFILES_DIR/nvim" ]]; then
        echo "【Neovim】"
        echo "  • LSP サーバーをインストール: :Mason"
        echo "  • 推奨 LSP: lua-language-server, pyright, typescript-language-server,"
        echo "              rust-analyzer, gopls, marksman"
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
        echo "    sudo cp ~/.wsl/wsl.conf /etc/wsl.conf"
        echo "    （PowerShell で） wsl --shutdown"
        echo ""
    fi
}
