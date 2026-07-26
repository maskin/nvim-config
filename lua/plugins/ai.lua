-- =====================================================================
--  AI: avante.nvim  —  CursorライクなAI編集 in Neovim
--    provider = glm(z.ai) / claude(z.ai) / gemini / copilot
--
--    <leader>aa   Ask (質問)            <leader>ae   Edit (選択範囲を書替)
--    <leader>at   Toggle panel          <leader>ar   Refresh
--    <leader>as   Switch provider       (glm / claude / gemini / copilot)
--
--  ※ GLM は .zshrc の ANTHROPIC_AUTH_TOKEN(z.aiキー)をそのまま使用。
--    Claude も同一キーで ANTHROPIC_BASE_URL(api.z.ai)経由。
-- =====================================================================
return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      "zbirenbaum/copilot.lua",
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = { default = { dir = vim.fn.stdpath("state") .. "/avante/images" } },
      },
      "MeanderingProgrammer/render-markdown.nvim",
    },
    opts = {
      -- 既定 = GLM(z.ai OpenAI互換)。実績のある同じAPIキーで確実動作。
      provider = "glm",
      -- 新schema: vendors廃止 → providersに統合
      providers = {
        -- Claude via z.ai (.zshrc の ANTHROPIC_BASE_URL / AUTH_TOKEN を再利用)
        claude = {
          model = "claude-sonnet-4-5",
          api_key_name = "ANTHROPIC_AUTH_TOKEN",
          endpoint = vim.env.ANTHROPIC_BASE_URL,
        },
        -- GLM via z.ai OpenAI互換 (既定provider)
        glm = {
          __inherited_from = "openai",
          endpoint = "https://api.z.ai/api/paas/v4",
          model = "glm-4.6",
          api_key_name = "ANTHROPIC_AUTH_TOKEN",
        },
        -- Gemini (GEMINI_API_KEY が必要)
        gemini = {
          __inherited_from = "openai",
          endpoint = "https://generativelanguage.googleapis.com/v1beta/openai",
          model = "gemini-2.5-pro",
          api_key_name = "GEMINI_API_KEY",
        },
      },
      behaviour = {
        auto_suggestions = false,                 -- 補完は既存 copilot.lua に任せる
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = true,
        enable_cursor_planning_mode = false,
      },
      hints = { enabled = true },
      windows = {
        sidebar = { width = 42 },
        ask = { floating = false },
      },
    },
    -- provider切替ヘルパのみ追記(ask/edit/toggleはデフォルトmapping)
    keys = {
      {
        "<leader>as",
        function()
          local p = vim.fn.input("AI provider [glm/claude/gemini/copilot]: ", "glm")
          if p ~= "" then vim.cmd("AvanteSwitchProvider " .. p) end
        end,
        desc = "AI: Switch provider",
      },
    },
  },
}
