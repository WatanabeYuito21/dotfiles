---
description: 設定変更後に README.md と CLAUDE.md を最新の状態に同期する
---

直前の設定変更に合わせて README.md と CLAUDE.md を更新してください。

## 手順

### 1. 変更差分を把握する

```bash
git diff HEAD
git diff --cached
```

未コミットの変更がなければ直近コミットを確認する:

```bash
git diff HEAD~1..HEAD
```

### 2. 影響範囲を判定する

変更されたファイルと、それに対応するドキュメント箇所の対応:

| 変更ファイル | 更新すべき箇所 |
|---|---|
| `nvim/lua/lsp/servers.lua` | 対応言語・LSP テーブル |
| `nvim/lua/plugins/formatter.lua` | 対応言語・LSP テーブル（フォーマッター列） |
| `nvim/lua/plugins/*.lua` | プラグイン一覧・キーバインド説明 |
| `nvim/lua/options.lua` | Neovim 設定の説明 |
| `scripts/installers/*.sh` | セットアップ手順・要件 |
| `setup.sh` | セットアップコマンド例 |
| `tmux/tmux.conf` | tmux 設定の説明 |
| `bash/bashrc` | bash 設定の説明 |
| `wsl/wsl.conf` | WSL 設定の説明 |

### 3. README.md を更新する

- 実態と乖離している記述を修正する
- 新機能・新設定は該当セクションに追記する
- 削除した設定はドキュメントからも削除する
- バージョン要件が変わっていれば `## 📋 要件` セクションを更新する

### 4. CLAUDE.md を更新する

- アーキテクチャ説明が変わっていれば修正する
- 対応言語・LSP テーブルを更新する
- 「新しい言語を追加する場合」「プラグインを追加する場合」等の手順が変わっていれば修正する

## 注意事項

- 変更に直接関係しないセクションは触らない
- 実装を読んで事実と一致する記述にする（推測で書かない）
- 更新後に「どのセクションを何の理由で変更したか」を箇条書きで報告する
