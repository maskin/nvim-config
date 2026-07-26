# AI-era Dev Setup (maskin)

Neovim + Git + AI (GLM / Claude / Gemini / Copilot) + Cursor / Monica 連携。

## AI in Neovim — avante.nvim

Cursor ライクな AI 編集パネル。provider を切り替えて GLM / Claude / Gemini / Copilot を使える。

| Key            | Action                                  |
|----------------|-----------------------------------------|
| `<leader>aa`   | Ask（チャットで質問）                    |
| `<leader>ae`   | Edit（選択範囲を書き替え。vibual-mode）  |
| `<leader>at`   | Toggle AI panel                         |
| `<leader>ar`   | Refresh                                 |
| `<leader>as`   | **Switch provider** (glm/claude/gemini/copilot) |

### Provider 構成
- **glm** (既定) — z.ai OpenAI 互換 (`api.z.ai/api/paas/v4`, model `glm-4.6`)
- **claude** — z.ai Anthropic 互換 (`ANTHROPIC_BASE_URL`, model `claude-sonnet-4-5`)
- **gemini** — `GEMINI_API_KEY` が必要（未設定なら `as` → `gemini` は失敗）
- **copilot** — 既存の GitHub Copilot 認証を流用

> どちらの z.ai 経路も `.zshrc` の `ANTHROPIC_AUTH_TOKEN` を使う。
> モデル差替えは `lua/plugins/ai.lua` の `model` を編集。

### モデル一覧（z.ai）
`glm-4.6`(既定/最強) / `glm-4.5` / `glm-4.5-air`(高速) / `glm-4.5-flash` / `glm-4.5v`(画像)。

## AI コミットメッセージ（Shell）

```sh
gaimsg            # diff からメッセージ生成（表示のみ）
gaic              # git add -A → 生成メッセージで commit
GIT_AI_MODEL=glm-4.5-air gaic   # モデル切替
```
GLM に Conventional Commits メッセージを生成させる。`~/.zshrc` に定義。

## Git (Neovim)
| Key            | Action                          |
|----------------|---------------------------------|
| `<leader>gg`   | **lazygit** (float)             |
| `<leader>gd` / `gD` | Diffview open / close      |
| `<leader>gf` / `gL` | file / repo history        |
| `]h` / `[h`    | 次 / 前 の hunk                 |
| `<leader>hs`   | stage hunk                      |
| `<leader>hr`   | reset hunk                      |
| `<leader>hp`   | preview hunk                    |
| `<leader>hb`   | blame line                      |

行内 blame は常時表示（`current_line_blame`）。

## Git (Shell)
`g lg/gs/gd/gl` / `git st/lg/ci/ca/wip/undo/cleanup-merged`。
`pull.rebase`, `push.autoSetupRemote`, `rerere`, `merge.conflictstyle=zdiff3` 済み。
差分を見やすくするなら `brew install git-delta` → `.gitconfig` の delta 行を有効化。

## Cursor 連携
- Shell: `ch` / `cursor_here [path]` でカレントを Cursor で開く。
- Neovim: `<leader>oC` で現在ファイル:行を Cursor で開く。
- Skills は `~/.cursor/skills` と `~/.continue/skills` で Cursor/Continue と共有。

## Monica 連携
- Shell: `monica` で Web App（Chrome app モード）を起動。
- Neovim: `<leader>om`。
- ※ Monica にネイティブ CLI / Neovim プラグインは無し。
  有料プランの API キーがあれば `lua/plugins/ai.lua` の `vendors` に
  OpenAI 互換 endpoint として追加すれば avante から使える。

## セットアップ後の初回起動
```sh
nvim        # → lazy.nvim が新プラグイン(avante等)を自動インストール
:Lazy sync  # 確実に揃える
:Copilot auth  # 初回のみ（未認証なら）
```
avante.nvim のビルド(`make`)は macOS arm64 の prebuilt を取得。

## トラブルシュート
- **AI が 401/403**: `echo $ANTHROPIC_AUTH_TOKEN` で z.ai キーが有効か。
- **avante のビルドが `make: *** [luajit] Error 1` で失敗する**:
  ほぼ GitHub API の無認証レート制限(60/h)が原因。`build.sh` がアセットURLを引けず
  `curl -L "" | tar` で落ちている。`gh`(認証済み)で直接取得して解決済みだが、
  avante 更新時に再発する可能性あり。その際は以下を再実行:
  ```sh
  cd ~/.local/share/nvim/lazy/avante.nvim
  tag=$(git describe --tags --abbrev=0 --match 'v*')           # 例: v0.1.2
  arch=$(uname -m); [ "$arch" = arm64 ] && arch=aarch64
  gh release download "$tag" --repo yetone/avante.nvim \
    --pattern "avante_lib-darwin-$arch-luajit.tar.gz" --dir /tmp/ab --clobber
  tar -zxvf /tmp/ab/avante_lib-darwin-$arch-luajit.tar.gz -C lua/
  echo -n "$tag" > lua/.tag
  ```
- **日本語の罫線がずれる**: 一部ターミナル/プラグインで `ambiwidth` 衝突。`init.lua` の `listchars` は安全設定済み。
