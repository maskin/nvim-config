# Changelog

nvim-config (maskin) の変更履歴。
[kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) をベースにした独自変更のみを記載。

- コミットの詳細は `git log` を参照
- AI・Git 連携の使い方は [AI_SETUP.md](./AI_SETUP.md) を参照

## 2026-07-27

### AI-era setup & `lua/plugins` 移行 — `524f3ea`

kickstart 由来の多ファイル構成を廃止し、プラグイン実体を `lua/plugins/*.lua` へ集約。
日本語環境と AI 編集を前提に `init.lua` を刷新した。

**追加**
- `lua/plugins/ai.lua` — avante.nvim。glm(z.ai) / claude / gemini / copilot を切り替えられる AI 編集パネル
- `lua/plugins/editor.lua` — nvim-autopairs / indent-blankline / Comment.nvim / flash.nvim / suda.vim
- `lua/plugins/git.lua` — gitsigns + diffview + lazygit(toggleterm)
- `AI_SETUP.md` — AI・Git・Cursor・Monica 連携の包括的ドキュメント

**`init.lua`**
- 日本語 / encoding / UI / 挙動オプションを整備（ambiwidth は E1512 回避で single のまま）
- キーマップ: `<leader>w/q/x`、`<C-hjkl>` ウィンドウ移動、`<leader>oC`(Cursor連携)、`<leader>om`(Monica)
- autocmds: yank ハイライト、カーソル位置復元、ファイルタイプ別インデント、ターミナル ESC
- lazy.nvim: インストール時のカラースキーム指定、change_detection の無効化、標準プラグインの除外で起動高速化

**削除**
- `lua/kickstart/*`, `lua/custom/*`, `plugins/copilot.lua`（`lua/plugins` へ統合）
- 誤生成バックアップ `~`, `~~~`、`init.lua.backup_encoding`

## 2026-01-14

### E1512 修正 — `68249e7`
listchars を単純化し ambiwidth を無効化して E1512 エラーを回避。

### encoding 修正 — `9c5090c`
Neovim 互換性のためのエンコーディングオプション調整。

### initial neovim config — `6a38f36`
kickstart.nvim ベースの初期設定。
