---
description: dotfiles をこのマシンに適用する。コンポーネント指定や dry-run も可能
---

dotfiles のセットアップスクリプトを実行してください。

引数: $ARGUMENTS

## 実行ルール

- 引数が空の場合: `./setup.sh --dry-run` でまず確認内容を表示し、実行してよいか確認してから `./setup.sh` を実行する
- `--dry-run` が含まれる場合: `./setup.sh $ARGUMENTS` をそのまま実行して結果を表示する
- それ以外: `./setup.sh $ARGUMENTS` を実行する

## 使用例

```
/sync                        # 全コンポーネントを適用
/sync --only nvim            # nvim のみ
/sync --only nvim,tmux       # nvim + tmux
/sync --dry-run              # 変更内容の事前確認
/sync --only bash --dry-run  # bash のみ dry-run
```

対応コンポーネント: `nvim` `tmux` `bash` `wsl`
