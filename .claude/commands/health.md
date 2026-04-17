---
description: dotfiles が依存するツールのインストール状況とバージョンを確認する
---

以下のツールの状態を確認して、インストール状況とバージョンを一覧表示してください。

```bash
# 必須
git --version
nvim --version | head -1

# エディタツール
stylua --version 2>/dev/null || echo "NOT FOUND"
black --version 2>/dev/null || echo "NOT FOUND"
isort --version 2>/dev/null || echo "NOT FOUND"
prettier --version 2>/dev/null || echo "NOT FOUND"
rustfmt --version 2>/dev/null || echo "NOT FOUND"
gofmt -h 2>&1 | head -1 || echo "NOT FOUND"

# 言語ランタイム
python3 --version 2>/dev/null || echo "NOT FOUND"
pyenv --version 2>/dev/null || echo "NOT FOUND"
node --version 2>/dev/null || echo "NOT FOUND"
rustc --version 2>/dev/null || echo "NOT FOUND"
go version 2>/dev/null || echo "NOT FOUND"

# その他
tmux -V 2>/dev/null || echo "NOT FOUND"
uv --version 2>/dev/null || echo "NOT FOUND"
```

上記を Bash で実行して結果を収集し、以下のフォーマットで報告する:

```
## ✅ インストール済み
| ツール | バージョン |
|--------|-----------|
| ...    | ...       |

## ❌ 未インストール
- ...（インストール方法を添える）
```
