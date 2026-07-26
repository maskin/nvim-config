-- =====================================================================
--  init.lua — AI-era Neovim config (maskin)
--  GLM(z.ai) / Claude / Gemini / Copilot 対応
--  Plugin実体は lua/plugins/*.lua / leader = <Space>
-- =====================================================================

-- Leader -------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

-- Encoding & 日本語 --------------------------------------------------
-- ambiwidthはsingleのまま(E1512回避)。listcharsは安全な組合せのみ。
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.spelllang = { "en", "cjk" }   -- cjk = 日本語をスペルチェック対象外

-- UI -----------------------------------------------------------------
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.showmode = false              -- lualine が表示
vim.opt.cmdheight = 1
vim.opt.laststatus = 3
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.wrap = false
vim.opt.breakindent = true
vim.opt.termguicolors = true
vim.opt.list = true
vim.opt.listchars = { tab = "  ", trail = "·", nbsp = "␣", extends = "›", precedes = "‹" }
vim.opt.fillchars = { eob = " ", vert = "│", fold = " ", diff = "╱" }

-- 挙動 ---------------------------------------------------------------
vim.opt.clipboard = "unnamedplus"
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "split"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.confirm = true
vim.opt.re = 0                         -- 正規表現エンジン(0=自動/最新)

-- =====================================================================
--  Keymaps
-- =====================================================================
local map = vim.keymap.set

map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>x", "<cmd>x<cr>", { desc = "Save & Quit" })

-- ウィンドウ移動 <C-hjkl>
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")
map("t", "<C-h>", "<C-\\><C-n><C-w>h")
map("t", "<C-j>", "<C-\\><C-n><C-w>j")
map("t", "<C-k>", "<C-\\><C-n><C-w>k")
map("t", "<C-l>", "<C-\\><C-n><C-w>l")

-- 表示行移動 / ヤンク改善
map("n", "j", "gj")
map("n", "k", "gk")
map("n", "Y", "y$")
map("x", "p", '"_dP')                  -- ペーストでレジスタを汚さない
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank → clipboard" })
map("n", "<leader>Y", '"+Y', { desc = "Yank line → clipboard" })
map("n", "<esc><esc>", "<cmd>nohlsearch<cr>")

-- バッファ/タブ
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>bprev<cr>", { desc = "Prev buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- Cursor連携: 現在ファイル:行をCursorで開く
map("n", "<leader>oC", function()
  local f = vim.fn.expand("%:p")
  if f == "" then vim.notify("buffer has no file", vim.log.levels.WARN); return end
  vim.fn.jobstart({ "cursor", f .. ":" .. vim.fn.line(".") }, { detach = true })
  vim.notify("Cursor: " .. f .. ":" .. vim.fn.line("."))
end, { desc = "Open in Cursor" })

-- Monica連携: ブラウザで開く(ネイティブCLI/APIはないため)
map("n", "<leader>om", function()
  vim.fn.jobstart({ "open", "https://monica.im" }, { detach = true })
end, { desc = "Open Monica (web)" })

-- =====================================================================
--  Autocmds
-- =====================================================================
local aug = vim.api.nvim_create_augroup("maskin", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = aug,
  callback = function() vim.hl.on_yank({ higroup = "IncSearch", timeout = 200 }) end,
})

-- 前回のカーソル位置を復元
vim.api.nvim_create_autocmd("BufReadPost", {
  group = aug,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    if mark[1] > 1 and mark[1] <= vim.api.nvim_buf_line_count(0) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- ファイルタイプ別インデント
vim.api.nvim_create_autocmd("FileType", {
  group = aug,
  pattern = { "json", "jsonc", "markdown", "yaml", "html", "css", "javascript", "typescript" },
  callback = function() vim.bo.shiftwidth = 2; vim.bo.tabstop = 2 end,
})

-- ターミナルをESCで抜ける
vim.api.nvim_create_autocmd("TermOpen", {
  group = aug,
  callback = function() map("t", "<esc>", "<C-\\><C-n>", { buffer = true }) end,
})

-- =====================================================================
--  lazy.nvim
-- =====================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  install = { colorscheme = { "tokyonight-night" } },
  checker = { enabled = true, frequency = 3600 * 6, notify = false },
  change_detection = { notify = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip", "matchit", "matchparen", "netrwPlugin", "tarPlugin",
        "tohtml", "tutor", "zipPlugin",
      },
    },
  },
})
