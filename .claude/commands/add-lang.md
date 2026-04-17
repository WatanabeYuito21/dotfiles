---
description: 新しい言語の LSP・フォーマッター設定を dotfiles に追加する
---

言語: $ARGUMENTS

以下の手順で新しい言語サポートを追加してください。

## 手順

### 1. LSP サーバーを追加（`nvim/lua/lsp/servers.lua`）

`vim.lsp.config` API で追加する。既存のパターンを参考にすること:
- `command -v <server>` で実行可能かチェックしてから設定する
- `capabilities` は `require('lsp.capabilities').get()` を使う

### 2. フォーマッターを追加（`nvim/lua/plugins/formatter.lua`）

`formatters_by_ft` に対象 filetype を追加する。
Neovim の filetype 名を確認すること（例: `ps1` は PowerShell、`rust` は Rust）。

### 3. CLAUDE.md の対応言語テーブルを更新

`## 対応言語・LSP` テーブルに行を追加する。

### 4. README.md の対応言語テーブルを更新

同様にテーブルへ追加する。

## 確認事項

- LSP サーバーのパッケージ名（Mason でインストールできるか）
- フォーマッターの名前（conform.nvim が対応しているか）
- Neovim の filetype 名（`:set filetype?` または `:h filetype` で確認）

作業後、変更ファイル一覧と「Mason でのインストールコマンド」を報告する。
