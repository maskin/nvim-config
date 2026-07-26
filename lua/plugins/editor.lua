-- =====================================================================
--  Editor: autopairs / indent guides / comment / flash / suda
-- =====================================================================
return {
  -- 自動カッコ閉じ
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- インデントガイド(スコープ付き)
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      indent = { char = "│" },
      scope = { enabled = true, show_start = false, show_end = false },
      exclude = {
        filetypes = { "alpha", "dashboard", "lazy", "mason", "neo-tree", "oil", "help" },
      },
    },
  },

  -- コメント切替 gcc / gbc (motion: gc)
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },

  -- 高速ジャンプ・周辺選択 (s / S)
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash jump" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash treesitter" },
    },
  },

  -- sudo で書込み (:SudaWrite)
  { "lambdalisue/suda.vim", cmd = { "SudaWrite", "SudaRead" } },
}
