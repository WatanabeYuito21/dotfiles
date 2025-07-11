#!/usr/bin/env bash

# 推奨事項の表示
show_recommendations() {
    log_info "セットアップ後の推奨事項:"
    echo ""
    echo "【Neovim】"
    echo "  • LSPサーバーをインストール: :Mason"
    echo "  • 推奨LSPサーバー:"
    echo "    - Lua: lua-language-server"
    echo "    - Python: pyright"
    echo "    - TypeScript/JavaScript: typescript-language-server"
    echo "    - Rust: rust-analyzer"
    echo "    - Go: gopls"
    echo "    - PowerShell: PowerShell Editor Services"
    echo "    - Markdown: marksman"
    echo ""

    if [ -d "$DOTFILES_DIR/tmux" ]; then
        echo "【tmux】"
        if command -v tmux &> /dev/null; then
            echo "  • tmux起動後に Prefix + I でプラグインをインストール"
            echo "  • Prefix キーは Ctrl-j に設定されています"
            echo "  • vim風のキーバインドが設定されています"
        else
            echo "  • tmuxをインストールしてください: sudo apt install tmux"
        fi
        echo ""
    fi

    if [ -f "$DOTFILES_DIR/bash/bashrc" ]; then
        echo "【bash】"
        echo "  • 履歴共有機能が有効になっています"
        echo "  • pyenv が設定されています（Python バージョン管理）"
        echo "  • Cargo が設定されています（Rust 開発環境）"
        echo "  • WSL2 サポートが含まれています"
        if ! command -v pyenv &> /dev/null; then
            echo "  • pyenv をインストールすることをお勧めします:"
            echo "    curl https://pyenv.run | bash"
        fi
        if ! command -v cargo &> /dev/null; then
            echo "  • Rust をインストールすることをお勧めします:"
            echo "    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
        fi
        echo ""
    fi

    if is_wsl && [ -f "$DOTFILES_DIR/wsl/wsl.conf" ]; then
        echo "【WSL】"
        echo "  • WSL設定が適用されました"
        echo "  • 設定を完全に反映するには以下を実行してください:"
        echo "    PowerShell/コマンドプロンプト: wsl --shutdown"
        echo "    その後、WSLを再起動してください"
        echo ""
    fi
}
