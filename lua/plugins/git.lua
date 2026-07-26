-- =====================================================================
--  Git: gitsigns + diffview + lazygit(toggleterm)
--    ]h/[h        次のhunk / 前のhunk
--    <leader>hs   stage hunk    <leader>hr  reset hunk
--    <leader>hp   preview hunk  <leader>hb  blame line
--    <leader>hd   diffthis      <leader>hD  diffthis (HEAD)
--    <leader>gg   lazygit (float)
--    <leader>gd   DiffviewOpen   <leader>gD  DiffviewClose
--    <leader>gf   file history
-- =====================================================================
return {
  -- gitsigns: signcolumn + hunk操作 + 行内blame
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "┆" },
      },
      signs_staged_enable = true,
      current_line_blame = true,
      current_line_blame_opts = { delay = 300, virt_text = true, virt_text_pos = "eol" },
      current_line_blame_formatter = " <author>, <author_time:%Y-%m-%d> • <summary>",
    },
    keys = {
      { "]h", function() require("gitsigns").nav_hunk("next") end, desc = "Next hunk" },
      { "[h", function() require("gitsigns").nav_hunk("prev") end, desc = "Prev hunk" },
      { "<leader>hs", function() require("gitsigns").stage_hunk() end, desc = "Stage hunk" },
      { "<leader>hr", function() require("gitsigns").reset_hunk() end, desc = "Reset hunk" },
      { "<leader>hS", function() require("gitsigns").stage_buffer() end, desc = "Stage buffer" },
      { "<leader>hp", function() require("gitsigns").preview_hunk() end, desc = "Preview hunk" },
      { "<leader>hb", function() require("gitsigns").blame_line() end, desc = "Blame line" },
      { "<leader>hd", function() require("gitsigns").diffthis() end, desc = "Diff buffer" },
      { "<leader>hD", function() require("gitsigns").diffthis("~") end, desc = "Diff buffer (HEAD)" },
    },
  },

  -- diffview: ブランチ/コミット比較・ファイル履歴
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview open" },
      { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Diffview close" },
      { "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
      { "<leader>gL", "<cmd>DiffviewFileHistory<cr>", desc = "Repo history" },
    },
    opts = {
      view = { merge_tool = { layout = "diff3_mixed" } },
    },
  },

  -- toggleterm: lazygit をフロートで起動
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = "ToggleTerm",
    keys = "<leader>gg",
    opts = {
      direction = "float",
      float_opts = { border = "rounded" },
      highlights = { Normal = { link = "Normal" }, NormalFloat = { link = "Normal" } },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)
      local Terminal = require("toggleterm.terminal").Terminal
      local lazygit = Terminal:new({
        cmd = "lazygit",
        hidden = true,
        direction = "float",
        float_opts = { border = "rounded" },
        on_open = function(_) vim.cmd("startinsert!") end,
      })
      vim.keymap.set("n", "<leader>gg", function() lazygit:toggle() end, { desc = "Lazygit (float)" })
    end,
  },
}
